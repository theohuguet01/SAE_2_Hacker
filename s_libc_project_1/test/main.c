#include <stdio.h>
#include "s_stdio.h"
#include "s_string.h"

int main() {
    // === Test s_puts ===
    printf("=== Test s_puts ===\n");
    printf("Résultat attendu : Hello World\n");
    printf("Résultat obtenu  : ");
    fflush(stdout);
    s_puts("Hello World");

    printf("Résultat attendu : Bonjour\n");
    printf("Résultat obtenu  : ");
    fflush(stdout);
    s_puts("Bonjour");

    printf("Résultat attendu : (ligne vide)\n");
    printf("Résultat obtenu  : ");
    fflush(stdout);
    s_puts("");

    // === Test s_strcpy ===
    printf("=== Test s_strcpy ===\n");
    char dest[50];
    s_strcpy(dest, "Hello");
    printf("s_strcpy: %s\n", dest);

    return 0;
}