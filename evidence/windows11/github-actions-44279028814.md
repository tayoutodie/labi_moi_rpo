# Подтверждённый запуск Windows CI

Источник: [GitHub Actions run 44279028814](https://github.com/tayoutodie/labi_moi_rpo/actions/runs/44279028814), job `smoke-windows` (ID 134714494222). Статус **success**, 18 ноября 2026 года.

| Проверка | Результат |
|---|---|
| ОС раннера | Microsoft Windows Server 2025 Datacenter (не ПК студента) |
| Python | 3.13.17 |
| Компилятор | MSVC `cl` |
| ЛР 1 C | `agent v0, pid=7696` — PASS |
| ЛР 1 Python | `agent v0 (python), pid=9120` — PASS |
| ЛР 2 | `agent: total=6 area=12` — PASS |
| ЛР 3 | `sqrt(2) = 1.414214` — PASS |

Это выдержка из настоящего журнала CI. Номера PID принадлежат временному GitHub runner, а не Windows 11 студента. Проверка подтверждает **сборку и запуск** указанного кода, но не отладку, наблюдение за процессами, измерение памяти или выполнение остальных лабораторных.
