#include <stdio.h>
struct Point { int x, y; };
static int area(struct Point p) { return p.x * p.y; }
int main(void) {
    struct Point p = {0, 0};
    char name[] = "agent";
    int total = 0;
    p.x = 3;
    p.y = 4;
    for (int i = 0; i < 4; ++i) total += i;
    int a = area(p);
    printf("%s: total=%d area=%d\n", name, total, a);
    return 0;
}
