//
// C function called by example_013.F90
//
#include <stdio.h>

int print_string(char *s, long long lngt)
{
    printf("C: %s(): string : '%s'\n", __func__, s);
    return 0;
}
