"""Inspect process ancestry and observe the parent of a spawned process."""
import os
import subprocess

print(f"Python PID={os.getpid()}, PPID={os.getppid()}")
child = subprocess.Popen(["sleep", "3"])
try:
    print(f"Child PID={child.pid}")
    subprocess.run(["ps", "-o", "pid=,ppid=,comm=", "-p", str(child.pid)], check=False)
finally:
    child.wait()
