"""Spawn a child, observe exit status and missing executable."""
import os
import subprocess
import sys

print("parent pid:", os.getpid(), flush=True)
child = subprocess.Popen([sys.executable, "-c",
 "import os,sys; print('child', os.getpid(), 'parent', os.getppid(), flush=True);sys.exit(7)"])
print("child exit:", child.wait())
try:
    subprocess.run(["sysprog-command-does-not-exist-123"], check=True)
except FileNotFoundError as e:
    print("missing executable:", type(e).__name__, "errno", e.errno)
