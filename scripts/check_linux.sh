#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
cc -Wall -Wextra -Werror -o "$tmp/hello" labs/01-process-inside/hello.c
printf '\n' | "$tmp/hello" | grep -Eq '^agent v0, pid=[0-9]+$'
printf '\n' | python3 labs/01-process-inside/hello.py | grep -Eq '^agent v0 \(python\), pid=[0-9]+$'
cc -Wall -Wextra -Werror -g -O0 -o "$tmp/debug" labs/02-debugger/debug.c
"$tmp/debug" | grep -q 'agent: total=6 area=12'
cc -Wall -Wextra -Werror -o "$tmp/libs" labs/03-libraries/libs.c -lm
"$tmp/libs" | grep -q 'sqrt(2) = 1.414214'
cc -Wall -Wextra -Werror -o "$tmp/fixed" labs/09-crash/fixed_crash.c
"$tmp/fixed" | grep -q 'Memory errors prevented'
python3 -m py_compile labs/*/*.py
echo 'Smoke checks passed; screenshots and manual measurements still required.'
