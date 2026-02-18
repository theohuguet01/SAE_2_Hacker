#include <stdio.h>
#include "../include/s_string.h"
#include "../include/s_math.h"
#include "../include/s_stdio.h"
#include "../include/s_stdlib.h"

int main() {
    printf("========================================\n");
    printf("   Tests de la Super libc (s_libc)\n");
    printf("========================================\n\n");

    /* ---- Tests s_strlen ---- */
    printf("--- s_strlen ---\n");
    printf("s_strlen(\"Hello\") = %d (attendu: 5)\n", s_strlen("Hello"));
    printf("s_strlen(\"\") = %d (attendu: 0)\n", s_strlen(""));
    printf("s_strlen(\"Bonjour le monde\") = %d (attendu: 16)\n", s_strlen("Bonjour le monde"));
    printf("\n");

    /* ---- Tests s_strcpy ---- */
    // TODO: décommenter quand s_strcpy sera implémenté
    // char dest[50];
    // s_strcpy(dest, "Hello");
    // printf("--- s_strcpy ---\n");
    // printf("s_strcpy(dest, \"Hello\") = \"%s\" (attendu: \"Hello\")\n", dest);
    // printf("\n");

    /* ---- Tests s_abs ---- */
    // TODO: décommenter quand s_abs sera implémenté
    // printf("--- s_abs ---\n");
    // printf("s_abs(-42) = %d (attendu: 42)\n", s_abs(-42));
    // printf("s_abs(42) = %d (attendu: 42)\n", s_abs(42));
    // printf("s_abs(0) = %d (attendu: 0)\n", s_abs(0));
    // printf("\n");

    /* ---- Tests s_puts ---- */
    // TODO: décommenter quand s_puts sera implémenté
    // printf("--- s_puts ---\n");
    // s_puts("Hello depuis s_puts !");
    // printf("\n");

    printf("========================================\n");
    printf("   Fin des tests\n");
    printf("========================================\n");

    return 0;
}
