
$ErrorActionPreference = "Stop"
Set-StrictMode -Version Latest
$root = (Resolve-Path (Join-Path $PSScriptRoot "..")).Path
Set-Location $root
$dir = Join-Path $root "evidence/windows11"
New-Item -ItemType Directory -Force -Path $dir | Out-Null
$log = Join-Path $dir "local-run.txt"
$temp = Join-Path ([IO.Path]::GetTempPath()) ("sysprog-" + [guid]::NewGuid().ToString("N"))
New-Item -ItemType Directory -Force $temp | Out-Null
$started = $false
try {
  Start-Transcript -Path $log -Force | Out-Null
  $started = $true
  Write-Output "Windows smoke test $(Get-Date -Format o)"
  Get-CimInstance Win32_OperatingSystem | Select-Object Caption,Version,BuildNumber | Format-List | Out-String | Write-Output
  Get-CimInstance Win32_Processor | Select-Object Name,NumberOfCores,NumberOfLogicalProcessors | Format-List | Out-String | Write-Output
  $compiler = @("cl","gcc","clang") | Where-Object { Get-Command $_ -ErrorAction SilentlyContinue } | Select-Object -First 1
  if (-not $compiler) { throw "No C compiler: open Developer PowerShell for Visual Studio." }
  if (-not (Get-Command python -ErrorAction SilentlyContinue)) { throw "Python is not in PATH." }
  & python --version
  Write-Output "Compiler: $compiler"
  function Build([string]$source,[string]$name,[bool]$debug) {
    $src = Join-Path $root $source
    $exe = Join-Path $temp ($name + ".exe")
    if ($compiler -eq "cl") {
      $opts = @("/nologo","/W3","/Od",("/Fe:" + $exe),("/Fo:" + (Join-Path $temp ($name + ".obj"))))
      if ($debug) { $opts += "/Zi" }
      $buildOutput = & cl @opts $src 2>&1
      $compileExit = $LASTEXITCODE
    } else {
      $opts = @("-Wall","-Wextra","-O0")
      if ($debug) { $opts += "-g" }
      $buildOutput = & $compiler @opts "-o" $exe $src 2>&1
      $compileExit = $LASTEXITCODE
    }
    foreach ($line in $buildOutput) { Write-Host $line }
    if ($compileExit -ne 0 -or -not (Test-Path $exe)) { throw "Compilation failed: $source" }
    return $exe
  }
  function Check([string]$title,[string]$output,[string]$expected) {
    Write-Output "$title : $output"
    if ($output -notmatch $expected) { throw "Unexpected output for $title" }
    Write-Output "PASS $title"
  }
  $hello = Build "labs/01-process-inside/hello.c" "hello" $false
  Check "Lab1 C" (("" | & $hello | Out-String).Trim()) "agent v0, pid=\d+"
  $pyOut = ("" | & python "labs/01-process-inside/hello.py" | Out-String).Trim()
  if ($LASTEXITCODE -ne 0) { throw "Python example failed" }
  Check "Lab1 Python" $pyOut "agent v0 \(python\), pid=\d+"
  $debug = Build "labs/02-debugger/debug.c" "debug" $true
  Check "Lab2 C" ((& $debug | Out-String).Trim()) "agent: total=6 area=12"
  $libs = Build "labs/03-libraries/libs.c" "libs" $false
  Check "Lab3 C" ((& $libs | Out-String).Trim()) "sqrt\(2\) = 1\.414214"
  Write-Output "Smoke checks passed; manual observations and screenshots remain."
} finally {
  if ($started) { Stop-Transcript | Out-Null }
  Remove-Item -Recurse -Force $temp -ErrorAction SilentlyContinue
}
