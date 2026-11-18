"""Time bounded CPU-bound work to compare CPU and wall time."""
import multiprocessing as mp
import os
import time

def load(queue):
    wall0 = time.monotonic()
    cpu0 = time.process_time()
    iterations = 0
    while time.monotonic() - wall0 < 2:
        iterations += 1
    wall = time.monotonic() - wall0
    cpu = time.process_time() - cpu0
    queue.put((os.getpid(), cpu, wall, iterations))

if __name__ == "__main__":
    mp.freeze_support()
    for count in (1, 2):
        queue = mp.Queue()
        processes = [mp.Process(target=load, args=(queue,)) for _ in range(count)]
        for p in processes:
            p.start()
        for _ in processes:
            pid, cpu, wall, iterations = queue.get()
            print(f"count={count} pid={pid} CPU={cpu:.3f}s wall={wall:.3f}s load={100*cpu/wall:.1f}% loops={iterations}")
        for p in processes:
            p.join()
