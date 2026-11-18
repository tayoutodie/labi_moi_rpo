# ЛР 3. Библиотеки программы

Система: **Windows 11 x64**, GCC MSYS2 UCRT64, Python **3.12.10 x64**.

## Библиотеки файла
Программа напечатала: **`sqrt(2) = 1.414214`**.
Команда импорта: **`objdump -p .\\labs\\03-libraries\\libs.exe | Select-String "DLL Name"`**.
Импорты `libs.exe` (9): **KERNEL32.dll**, **api-ms-win-crt-environment-l1-1-0.dll**, **api-ms-win-crt-heap-l1-1-0.dll**, **api-ms-win-crt-locale-l1-1-0.dll**, **api-ms-win-crt-math-l1-1-0.dll**, **api-ms-win-crt-private-l1-1-0.dll**, **api-ms-win-crt-runtime-l1-1-0.dll**, **api-ms-win-crt-stdio-l1-1-0.dll**, **api-ms-win-crt-string-l1-1-0.dll**.
Отдельная `libm.dll` не импортируется: математический API предоставляется средой **Universal CRT**.
Интерпретатор Python установлен через Microsoft Store (`WindowsApps`); найдены **python3.dll** и **python312.dll**. Прямой `objdump` для найденного `python.exe` не показал импортов.

## Библиотеки процесса
Python PID: **18416**.
Количество DLL по PowerShell до загрузки: **36**, после: **39** (**+3**).
Загружена **winmm.dll**, полный путь: **`C:\\WINDOWS\\SYSTEM32\\winmm.dll`**.
`ctypes.CDLL("winmm.dll")` и `timeGetTime()` дали значения **82005031** и **82152371** (миллисекунды системного таймера).

Не получилось / замечания: импортируемые DLL `python.exe` не получены через `objdump`; полный перечень DLL процесса по одному кадру Process Explorer не зафиксирован. Прирост +3 не доказывает, что каждая новая DLL загружена прямым вызовом `ctypes.CDLL`.

## Статус подтверждений

Данные разделов выше получены на Windows 11 студента, если прямо не обозначено CI. Результаты CI на Windows Server 2025 приведены отдельно и не заменяют локальные наблюдения. Некоторые кадры в `screenshots/` могут быть повторными или неполными; наличие файла не означает, что все требования экспериментально выполнены. Отсутствующие измерения обозначены явно.

## Реальные измерения на Windows 11 — шаги 1–2

Источник: два скриншота терминала Cursor, предоставленные студентом 18.11.2026.

**Сборка и выполнение:** команда `gcc -O0 .\\labs\\03-libraries\\libs.c -o .\\labs\\03-libraries\\libs.exe -lm` завершилась без видимых ошибок. При запуске `libs.exe` получено:

```text
sqrt(2) = 1.414214
```

**Импортируемые DLL:** команда `C:\\msys64\\ucrt64\\bin\\objdump.exe -p .\\labs\\03-libraries\\libs.exe | Select-String "DLL Name"` показала:

```text
KERNEL32.dll
api-ms-win-crt-environment-l1-1-0.dll
api-ms-win-crt-heap-l1-1-0.dll
api-ms-win-crt-locale-l1-1-0.dll
api-ms-win-crt-math-l1-1-0.dll
api-ms-win-crt-private-l1-1-0.dll
api-ms-win-crt-runtime-l1-1-0.dll
api-ms-win-crt-stdio-l1-1-0.dll
api-ms-win-crt-string-l1-1-0.dll
```

Итого **9 записей импорта DLL**. Это имена импортов PE-файла, а не полный перечень реально загруженных модулей процесса. Запись `api-ms-win-crt-math-l1-1-0.dll` относится к математическому API набора Universal CRT; отдельной `libm.dll` в списке нет. 
## Реальное наблюдение Python в Process Explorer (Windows 11)

Источник: скриншот Process Explorer, предоставленный студентом (после запуска интерактивного Python).

| Показатель | Фактическое значение |
|---|---:|
| Процесс | `python3.12.exe` |
| PID | **18416** |
| Private Bytes | **8 816 КБ** |
| Working Set | **23 564 КБ** |

В нижней панели DLLs видны `advapi32.dll`, `bcrypt.dll`, `bcryptprimitives.dll`, `cfgmgr32.dll`, `combase.dll`, `gdi32.dll`, `kernel32.dll`, `KernelBase.dll` и другие системные модули. Полный список и его количество **не определяются** по частичному скриншоту (панель прокручивается).


## Измерение числа DLL до и после загрузки (Windows 11)

Источник: два скриншота терминала PowerShell, присланные студентом. Наблюдается процесс Python **PID 18416**.

| Измерение | Результат |
|---|---|
| Команда подсчёта | `(Get-Process -Id 18416 -Module | Where-Object ModuleName -like "*.dll").Count` |
| Число DLL до | **36** |
| Число DLL после | **39** |
| Прирост | **3 DLL** |
| Модуль, обнаруженный после | `winmm.dll` |
| Полный путь | `C:\\WINDOWS\\SYSTEM32\\winmm.dll` |

Для поиска модуля использована команда `Get-Process -Id 18416 -Module | Where-Object ModuleName -like "winmm.dll" | Select-Object ModuleName,FileName`. Разница 39 − 36 = 3 подтверждена показанными результатами команды в PowerShell; **не утверждаем**, что все три DLL непосредственно загружены одной командой: возможны транзитивные зависимости и другие загрузки. Строка вызова `ctypes.CDLL("winmm.dll")` и результат `timeGetTime()` подтверждены отдельным последующим снимком, соответствующим `06_library_loaded.png`.

## Подтверждённый вызов WinMM через ctypes (Windows 11)

На скриншоте интерактивного Python **3.12.10, 64 bit (AMD64)**, PID **18416**, студент выполнил:

```python
import ctypes
lib = ctypes.CDLL("winmm.dll")
lib.timeGetTime.restype = ctypes.c_uint
print(lib.timeGetTime())
```

Первый зафиксированный результат: **82005031**, повторный: **82152371** (значения счётчика миллисекунд `timeGetTime`, не даты и не продолжительность выполнения функции). Оба вызова успешны. На предыдущем скриншоте PowerShell после загрузки наблюдались **39 DLL** против **36 DLL** до загрузки и модуль `C:\\WINDOWS\\SYSTEM32\\winmm.dll`.

**Уточнение:** раннее предположение о процессоре ARM64 по ошибке приписывалось среде Python; данный фактический 
Это реальное наблюдение для этапа `06_library_loaded.png`. 
## Подтверждённые результаты и анализ (Windows CI)

[Автопроверка Windows](https://github.com/tayoutodie/labi_moi_rpo/actions/runs/44279028814): сборка `libs.c` через MSVC и запуск **PASS**, вывод: `sqrt(2) = 1.414214`.

Ожидаемое объяснение: `sqrt` вызывается через доступную реализацию математических функций C; на Windows зависимости PE-файла показывают `dumpbin /dependents`, а загруженные в процесс DLL можно посмотреть в Process Explorer / Process Monitor. Отдельная DLL `libm` в Windows не обязательна — математическая функция может находиться в C runtime.


## Снимки экрана

Сохраните снимок поверх заглушки в папке `screenshots/` с тем же именем — ссылки ниже менять не нужно.

### 1. Сборка и запуск
Шаг 1. Видно: команда сборки и строка `sqrt(2) = 1.414214`.

![1. Сборка и запуск](screenshots/01_build_run.png)

### 2. Библиотеки файла libs
Шаг 2. Видно: вывод `dumpbin /dependents` / `otool -L` / `ldd` для своей программы.

![2. Библиотеки файла libs](screenshots/02_file_libraries.png)

### 3. Библиотеки интерпретатора Python
Шаг 3. Видно: тот же вывод для файла Python.

![3. Библиотеки интерпретатора Python](screenshots/03_python_libraries.png)

### 4. Номер процесса Python
Шаг 4. Видно: запущенный Python и его номер процесса.

![4. Номер процесса Python](screenshots/04_python_pid.png)

### 5. Библиотеки процесса до загрузки
Шаг 5. Видно: число библиотек процесса Python до `ctypes.CDLL`.

![5. Библиотеки процесса до загрузки](screenshots/05_libraries_before.png)

### 6. Библиотека загружена
Шаг 6. Видно: строка `ctypes.CDLL` и результат вызова функции библиотеки.

![6. Библиотека загружена](screenshots/06_library_loaded.png)

### 7. Библиотеки процесса после загрузки
Шаг 7. Видно: новое число библиотек и строка загруженной библиотеки.

![7. Библиотеки процесса после загрузки](screenshots/07_libraries_after.png)
