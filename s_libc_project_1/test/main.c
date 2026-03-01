#include <stdio.h>
#include <string.h>
#include <math.h>
#include "s_stdio.h"
#include "s_string.h"
#include "s_stdlib.h"
#include "s_math.h"

int main() {

    // === Test s_puts ===
    printf("=== Test s_puts ===\n");

    printf("Resultat attendu : Hello World\n");
    printf("Resultat obtenu  : ");
    fflush(stdout);
    s_puts("Hello World");

    printf("Resultat attendu : Bonjour\n");
    printf("Resultat obtenu  : ");
    fflush(stdout);
    s_puts("Bonjour");

    printf("Resultat attendu : (ligne vide)\n");
    printf("Resultat obtenu  : ");
    fflush(stdout);
    s_puts("");

    // === Test s_strlen ===
    printf("\n=== Test s_strlen ===\n");
    printf("s_strlen(\"Hello\") = %d (attendu %d) %s\n",
        s_strlen("Hello"), 5,
        s_strlen("Hello") == 5 ? "OK" : "FAIL");
    printf("s_strlen(\"\") = %d (attendu %d) %s\n",
        s_strlen(""), 0,
        s_strlen("") == 0 ? "OK" : "FAIL");
    printf("s_strlen(\"Bonjour le monde\") = %d (attendu %d) %s\n",
        s_strlen("Bonjour le monde"), 16,
        s_strlen("Bonjour le monde") == 16 ? "OK" : "FAIL");

    // === Test s_strcpy ===
    printf("\n=== Test s_strcpy ===\n");
    char dest1[50];
    s_strcpy(dest1, "Hello");
    printf("s_strcpy(dest, \"Hello\") = \"%s\" (attendu \"Hello\") %s\n",
        dest1, strcmp(dest1, "Hello") == 0 ? "OK" : "FAIL");

    char dest2[50];
    s_strcpy(dest2, "");
    printf("s_strcpy(dest, \"\") = \"%s\" (attendu \"\") %s\n",
        dest2, strcmp(dest2, "") == 0 ? "OK" : "FAIL");

    // === Test s_strncpy ===
    printf("\n=== Test s_strncpy ===\n");
    char dest3[50];
    memset(dest3, 'X', 50);
    s_strncpy(dest3, "Bonjour", 3);
    printf("s_strncpy(dest, \"Bonjour\", 3) = \"%.3s\" (attendu \"Bon\") %s\n",
        dest3, strncmp(dest3, "Bon", 3) == 0 ? "OK" : "FAIL");

    char dest4[50];
    memset(dest4, 'X', 50);
    s_strncpy(dest4, "Hi", 10);
    printf("s_strncpy(dest, \"Hi\", 10) = \"%s\" (attendu \"Hi\") %s\n",
        dest4, strcmp(dest4, "Hi") == 0 ? "OK" : "FAIL");
    // Verifier le padding avec \0
    int pad_ok = 1;
    for (int i = 2; i < 10; i++) {
        if (dest4[i] != '\0') pad_ok = 0;
    }
    printf("  padding \\0 apres \"Hi\" : %s\n", pad_ok ? "OK" : "FAIL");

    // === Test s_atoi ===
    printf("\n=== Test s_atoi ===\n");
    printf("s_atoi(\"42\") = %d (attendu 42) %s\n",
        s_atoi("42"), s_atoi("42") == 42 ? "OK" : "FAIL");
    printf("s_atoi(\"-123\") = %d (attendu -123) %s\n",
        s_atoi("-123"), s_atoi("-123") == -123 ? "OK" : "FAIL");
    printf("s_atoi(\"0\") = %d (attendu 0) %s\n",
        s_atoi("0"), s_atoi("0") == 0 ? "OK" : "FAIL");
    printf("s_atoi(\"+99\") = %d (attendu 99) %s\n",
        s_atoi("+99"), s_atoi("+99") == 99 ? "OK" : "FAIL");
    printf("s_atoi(\"abc\") = %d (attendu 0) %s\n",
        s_atoi("abc"), s_atoi("abc") == 0 ? "OK" : "FAIL");

    // === Test s_exp ===
    printf("\n=== Test s_exp ===\n");
    double r1 = s_exp(0.0);
    printf("s_exp(0.0) = %f (attendu 1.000000) %s\n",
        r1, fabs(r1 - 1.0) < 0.001 ? "OK" : "FAIL");
    double r2 = s_exp(1.0);
    printf("s_exp(1.0) = %f (attendu 2.718282) %s\n",
        r2, fabs(r2 - 2.718282) < 0.001 ? "OK" : "FAIL");
    double r3 = s_exp(2.0);
    printf("s_exp(2.0) = %f (attendu 7.389056) %s\n",
        r3, fabs(r3 - 7.389056) < 0.001 ? "OK" : "FAIL");

    printf("\n=== Tous les tests termines ===\n");

    return 0;
}