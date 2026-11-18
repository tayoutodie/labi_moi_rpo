#include <stdio.h>
#if defined(_WIN32)
#include <windows.h>
static unsigned long process_id(void) { return (unsigned long)GetCurrentProcessId(); }
#else
#include <unistd.h>
static unsigned long process_id(void) { return (unsigned long)getpid(); }
#endif
int main(void) {
    printf("agent v0, pid=%lu\n", process_id());
    fflush(stdout);
    puts("Press Enter to exit");
    (void)getchar();
    return 0;
}
