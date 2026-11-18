# ЛР 2 — Cursor / VS Code / Windows 11

Используется GCC из MSYS2 UCRT64 и GDB. Откройте **весь репозиторий** как рабочую папку Cursor, потому что конфигурации отладчика находятся в корневой `.vscode/`.

1. В **MSYS2 UCRT64** установите GDB:
   `pacman -S --needed mingw-w64-ucrt-x86_64-gdb`
2. В терминале Cursor проверьте `gcc --version` и `C:\msys64\ucrt64\bin\gdb.exe --version`.
3. В терминале Cursor из корня репозитория соберите и запустите:
   `gcc -g -O0 -Wall -Wextra .\labs\02-debugger\debug.c -o .\labs\02-debugger\debug.exe`;
   `.\labs\02-debugger\debug.exe`.
4. Ожидаемый вывод: `agent: total=6 area=12`.
5. Откройте `labs/02-debugger/debug.c`, поставьте breakpoint **на строке `p.x = 3;`**, а не на фиксированном номере из шаблона. Выберите конфигурацию **Lab 02: Debug C (Windows MSYS2 GDB)** и нажмите **F5**.
6. Используйте F10 (step over), F11 (step into), Variables, Watch, Call Stack и Disassembly. Заполните значения, реально увиденные при отладке, в `report.md`. Для каждого из восьми кадров сохраните снимок с именем из раздела «Снимки экрана».

В `debug.c` учебная программа записана компактно, поэтому номера строк отличаются от исходного шаблона. Чтобы видеть отдельные шаги внутри цикла, при необходимости разбейте однострочный `for` на несколько строк без изменения поведения.

Если путь к MSYS2 отличается от стандартного `C:\msys64`, обновите `miDebuggerPath` в корневом `.vscode/launch.json`.
