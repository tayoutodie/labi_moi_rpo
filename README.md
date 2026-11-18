# Системное программирование — лабораторные 1–9

Структура и исходники по [шаблону преподавателя](https://github.com/MaximBytecamp/sysprog-start-template), с отдельными папками и бланками отчётов для [всех девяти лабораторных](labs/README.md).

## Windows 11

Запуск автоматических проверок на ПК: откройте Developer PowerShell for Visual Studio и выполните команду:

    powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check_windows.ps1

Результаты записываются в evidence/windows11/local-run.txt. Есть также автоматическая проверка через GitHub Actions: Windows lab code checks.

[Инструкция для Windows](evidence/windows11/README.md) · [Результаты вспомогательных Linux-экспериментов](evidence/README.md).

## Статус

Исходники и структура подготовлены; реальные отчёты по наблюдениям в Windows, скриншоты и измерения Python 3.14t ещё не получены. Автоматическая сборка не равна полной сдаче девяти лабораторных.

Для Linux: bash scripts/check_linux.sh.
