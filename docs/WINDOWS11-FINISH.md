# Как закончить все девять лабораторных на Windows 11

Этот план дополняет оригинальные `labs/NN-*/README.md` и `report.md`, не заменяя их. Для каждого снимка используйте имя из раздела «Снимки экрана» соответствующего отчёта. Скриншот делается через **Win+Shift+S**, сохраняется в нужную папку `screenshots/` и заменяет заглушку. Не подменяйте снимки рисунками.

## Подготовка

- Python 3 (для ЛР 7 нужны отдельно 3.14 и 3.14t), Visual Studio с C++ tools или VS Code + MinGW/GDB.
- **Process Explorer**, **Process Monitor** и **VMMap** из Microsoft Sysinternals — для PID, дескрипторов, DLL, событий создания процессов и карты памяти.
- Developer PowerShell for Visual Studio, чтобы были доступны `cl` и `dumpbin`.
- Сначала выполните `powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check_windows.ps1` из корня репозитория.

## ЛР 1 — процесс изнутри

Соберите `hello.c` и запустите его **интерактивно** (не нажимайте Enter). Откройте Process Explorer, найдите напечатанный PID, запишите Private Bytes / Working Set / CPU Time, дескрипторы и DLL. Завершите процесс из Process Explorer, зафиксируйте реакцию терминала. Повторите для `hello.py`; для обычного выхода нажмите Enter и проверьте `$LASTEXITCODE`. Внесите наблюдения в [отчёт](../labs/01-process-inside/report.md).

## ЛР 2 — отладчик

Соберите `debug.c` с отладочной информацией (MSVC: `cl /Zi /Od debug.c`), откройте в Visual Studio, поставьте breakpoint на присваивание `p.x = 3`. Снимите состояние до/после, раскройте `name`, проследите `i` и `total`, зайдите в `area` (F11), откройте Call Stack и Disassembly. Сверяйте **операторы**, а не номера строк исходного шаблона. [Отчёт](../labs/02-debugger/report.md).

## ЛР 3 — библиотеки

Соберите `libs.c` и выполните `dumpbin /dependents .\libs.exe` в папке сборки. Найдите `python.exe` командой `(Get-Command python).Source` и проверьте зависимости. Для живого процесса Python используйте Process Explorer (DLLs), вызовите через `ctypes.CDLL` библиотеку и сравните количество DLL до/после. Не вписывайте заранее ожидаемое число библиотек. [Отчёт](../labs/03-libraries/report.md).

## ЛР 4 — дерево процессов

Откройте Process Explorer (View → Show Process Tree), найдите ветку терминала и браузера. В PowerShell проверьте `Get-CimInstance Win32_Process -Filter "ProcessId = 1234" | Select ProcessId,ParentProcessId,Name` (подставьте PID). Для эксперимента с завершившимся родителем используйте отдельную тестовую программу и зафиксируйте реальное поведение Windows: это **не** Unix-усыновление процессом PID 1. [Отчёт](../labs/04-process-tree/report.md).

## ЛР 5 — создание процесса

Запустите Process Monitor с фильтрами Process Create, Process Exit, Load Image и изучите запуск `hostname`. Запустите `python labs/05-process-birth/process_birth.py`, зафиксируйте PID родителя и ребёнка, код выхода 7, ошибку отсутствующей программы. [Отчёт](../labs/05-process-birth/report.md).

## ЛР 6 — CPU

Запустите `python labs/06-cpu-load/cpu_load.py`. Откройте Диспетчер задач (Производительность → ЦП → логические процессоры) или Process Explorer. Запишите загрузку при одной и двух нагрузках, затем сравните с ограничением affinity на одно ядро (через свойства процесса в Process Explorer). Не путайте проценты от **одного ядра** с процентами от **всех** логических процессоров. [Отчёт](../labs/06-cpu-load/report.md).

## ЛР 7 — GIL

Нужны обе сборки: обычный Python 3.14 и free-threaded Python 3.14t. Запустите `spin.py`, `threads.py`, `wait.py` в обеих, затем повторите free-threaded с `PYTHON_GIL=1`. Зафиксируйте фактическую версию и `sys._is_gil_enabled()`, время 1/2/4 потоков и загрузку CPU. **CI на Python 3.13 это не проверяет.** [Отчёт](../labs/07-python-threads/report.md).

## ЛР 8 — память

Запустите `python labs/08-memory-map/mem.py` и найдите его PID в выводе. Через VMMap и `Get-Process -Id <PID> | Select VirtualMemorySize64,WorkingSet64` снимите четыре этапа: старт, резервирование 300 МиБ, запись в страницы, освобождение. Затем `leak.py`: запишите пять последовательных замеров. Не путайте виртуальную память с рабочим набором. [Отчёт](../labs/08-memory-map/report.md).

## ЛР 9 — падения

**Только в тестовой среде:** соберите `crash.c` и `fixed_crash.c`. Запустите режимы `null`, `overflow`, `heap`, `uaf`; намеренно аварийный код может завершиться с ошибкой. Для heap и uaf включите MSVC AddressSanitizer (`/fsanitize=address /Zi`) и запишите **реальные** типы ошибок и строки из диагностики. Отдельно проверьте `ctypes_crash.py` и журнал событий Windows. Исправленный вариант не должен обращаться к памяти за границами или после освобождения. [Отчёт](../labs/09-crash/report.md).

## Перед сдачей

1. Уберите/замените заглушки в `screenshots/`, убедитесь, что изображения читаемы и соответствуют требуемому действию.
2. Заполните оставшиеся `___` в `report.md` **из фактических наблюдений**; неизвестные значения не угадывайте.
3. Убедитесь, что исходники компилируются и что Windows CI показывает зелёную галочку.
4. Проверьте скриншоты и журналы на личные данные перед публикацией.
