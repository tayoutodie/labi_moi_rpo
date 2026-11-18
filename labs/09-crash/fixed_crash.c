#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(void) {
    int *p = NULL;
    if (!p) puts("NULL write prevented");
    struct {int data[4]; int limit;} s = {{0}, 100};
    for (int i = 0; i < 4; ++i) s.data[i] = 7;
    printf("limit after fix: %d\n", s.limit);
    int *heap = malloc(4 * sizeof(*heap));
    if (!heap) return 1;
    for (int i = 0; i < 4; ++i) heap[i] = 7;
    free(heap);
    heap = NULL;
    char *name = malloc(16);
    if (!name) return 1;
    strcpy(name, "agent");
    printf("name before free: %s\n", name);
    free(name);
    name = NULL;
    puts("Memory errors prevented");
    return 0;
}
