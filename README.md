# Системное программирование — лабораторные №1–9

Репозиторий оформлен по [шаблону преподавателя](https://github.com/MaximBytecamp/sysprog-start-template) с девятью папками в [labs/](labs/README.md), исходниками и отчётами.

## Проверено

[Windows GitHub Actions — успешная сборка и запуск](evidence/windows11/github-actions-44279028814.md): ЛР 1 (C/Python), ЛР 2 и ЛР 3, Microsoft Windows Server 2025, MSVC, Python 3.13.17. [Журнал запуска](https://github.com/tayoutodie/labi_moi_rpo/actions/runs/44279028814).

[Вспомогательные измерения Linux](evidence/README.md) не являются наблюдениями с ПК студента.

## Как завершить лабораторные на Windows 11

**[Пошаговая инструкция по всем девяти работам](docs/WINDOWS11-FINISH.md)** — что запустить, что измерить, какие скриншоты сохранить и как заполнить `report.md`.

Локальная автоматическая проверка из Developer PowerShell для Visual Studio:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\check_windows.ps1
```

## Статус сдачи

**Программная часть подготовлена частично, все девять отчётов ещё не полностью заполнены.** Для сдачи требуются настоящие наблюдения, замеры и снимки экрана на Windows 11; успешный CI не заменяет их. В частности, ЛР 7 требует Python 3.14 и 3.14t, а ЛР 9 — отдельной проверки ошибок памяти.
