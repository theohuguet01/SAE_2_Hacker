#include <stdio.h>
#include <string.h>
#include "../include/s_string.h"

int main(void) {

    /* ==========================
       Test s_strcat
    ========================== */

    char a1[64] = "Hello ";
    char a2[64] = "Hello ";
    char b[] = "World!";

    char *ret = s_strcat(a1, b);
    strcat(a2, b);

    printf("---- TEST s_strcat ----\n");
    printf("s_strcat: '%s'\n", a1);
    printf("strcat  : '%s'\n", a2);
    printf("match   : %s\n", strcmp(a1, a2) == 0 ? "OK" : "NO");
    printf("ret==a1 : %s\n\n", (ret == a1) ? "OK" : "NO");


    /* ==========================
       Test s_strncat
    ========================== */

    char x1[64] = "Hello ";
    char x2[64] = "Hello ";
    char y[] = "World!!!";

    char *ret2 = s_strncat(x1, y, 3);
    strncat(x2, y, 3);

    printf("---- TEST s_strncat ----\n");
    printf("s_strncat: '%s'\n", x1);
    printf("strncat  : '%s'\n", x2);
    printf("match    : %s\n", strcmp(x1, x2) == 0 ? "OK" : "NO");
    printf("ret==x1  : %s\n", (ret2 == x1) ? "OK" : "NO");

    return 0;
}
