#include <stdio.h>
#include <string.h>
#include "../include/s_string.h"
#include "../include/s_math.h"
#include "../include/s_stdio.h"

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


    /* ==========================
       Test s_div
    ========================== */
    printf("\n---- TEST s_div ----\n");
    {
        int n = -5, d = 3;

        div_t r1 = s_div(n, d);
        div_t r2 = div(n, d);

        printf("s_div: quot=%d rem=%d\n", r1.quot, r1.rem);
        printf("div : quot=%d rem=%d\n", r2.quot, r2.rem);
        printf("match: %s\n", (r1.quot == r2.quot && r1.rem == r2.rem) ? "OK" : "NO");
    }

    
    /* ==========================
       Test s_fopen et s_fclose
    ========================== */
    printf("\n---- TEST s_fopen / s_fclose ----\n");

    FILE *f = s_fopen("testfile.txt", "w");
    if (!f) {
        perror("s_fopen");
    } else {
        fputs("Hello World !!!\n", f);

        int rc = s_fclose(f);
        printf("s_fclose returned: %d (%s)\n", rc, (rc == 0) ? "OK" : "ERR");

        /* Vérif simple: ré-ouvrir en lecture et lire */
        FILE *g = fopen("testfile.txt", "r");
        if (!g) perror("fopen(read)");
        else {
            char buf[32];
            fgets(buf, sizeof(buf), g);
            printf("read back: %s", buf);
            s_fclose(g);
        }
    }

    return 0;
}
