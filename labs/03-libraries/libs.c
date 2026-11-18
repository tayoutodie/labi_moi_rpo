#include <math.h>
#include <stdio.h>
int main(void) {
    volatile double argument = 2.0;
    printf("sqrt(2) = %.6f\n", sqrt(argument));
    return 0;
}
