import ctypes
import os
import sys

if sys.platform == "win32":
    kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
    kernel32.GetCurrentProcessId.restype = ctypes.c_ulong
    pid = kernel32.GetCurrentProcessId()
else:
    libc = ctypes.CDLL(None)
    libc.getpid.restype = ctypes.c_int
    pid = libc.getpid()

assert pid == os.getpid()
print(f"agent v0 (python), pid={pid}", flush=True)
try:
    input("Press Enter to exit")
except EOFError:
    pass
