# Проверка на Windows 11

Запустите на своём ПК из корня репозитория в Developer PowerShell для Visual Studio:

    powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check_windows.ps1

Требуются Python 3 и установленный компилятор Visual Studio C (или GCC / Clang). Реальный журнал запуска сохраняется в evidence/windows11/local-run.txt. Перед публикацией проверьте системные сведения и пути, чтобы не раскрыть личные данные.

GitHub Actions выполняет эти smoke-тесты на отдельной виртуальной машине Windows, а не на вашем ПК. Для сдачи всех девяти работ по шаблону преподавателя дополнительно нужны настоящие скриншоты и заполненные отчёты из папок labs.

Для ЛР 2: откройте debug.c в Visual Studio и используйте F9, F10, F11. Настройка VS Code в проекте использует GDB и подходит для MinGW/GDB, не для стандартного MSVC.

Для ЛР 7: отдельно нужен Python 3.14 и сборка Python 3.14t без GIL, обычная CI-проверка этой работы не заменяет.
