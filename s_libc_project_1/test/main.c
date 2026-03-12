#include <stdio.h>
#include <limits.h>

#include "../include/s_string.h"
#include "../include/s_math.h"
#include "../include/s_stdlib.h"
#include <stddef.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

#include "s_string.h"
#include "s_stdio.h"

static int total_tests = 0;
static int failed_tests = 0;

#define TEST(expr)                             \
    do                                         \
    {                                          \
        total_tests++;                         \
        if (!(expr))                           \
        {                                      \
            failed_tests++;                    \
            printf("[FAIL] %s:%d: %s\n",       \
                   __FILE__, __LINE__, #expr); \
        }                                      \
    } while (0)

static void test_s_strcmp(void)
{
    TEST(s_strcmp("abc", "abc") == 0);
    TEST(s_strcmp("abc", "abd") < 0);
    TEST(s_strcmp("abd", "abc") > 0);
    TEST(s_strcmp("", "") == 0);
    TEST(s_strcmp(NULL, NULL) == 0);
    TEST(s_strcmp(NULL, "a") < 0);
    TEST(s_strcmp("a", NULL) > 0);
}

static void test_s_strncmp(void)
{
    TEST(s_strncmp("abcdef", "abcxyz", 3) == 0);
    TEST(s_strncmp("abcdef", "abcxyz", 4) < 0);
    TEST(s_strncmp("abc", "abc", 0) == 0);
    TEST(s_strncmp(NULL, NULL, 5) == 0);
    TEST(s_strncmp(NULL, "abc", 2) < 0);
}

static void test_s_abs(void)
{
    TEST(s_abs(5) == 5);
    TEST(s_abs(-5) == 5);
    TEST(s_abs(0) == 0);

    /* Cas limite : INT_MIN (comportement défini dans ton asm) */
    TEST(s_abs(INT_MIN) == INT_MIN);
}

static void test_s_pow(void)
{
    TEST(s_pow(2.0, 3) == 8.0);
    TEST(s_pow(2.0, 0) == 1.0);
    TEST(s_pow(2.0, -2) == 0.25);
    TEST(s_pow(-2.0, 2) == 4.0);
    TEST(s_pow(-2.0, 3) == -8.0);
}

int main(void)
{
    printf("=== TEST LIB S_LIBC ===\n");

    test_s_strcmp();
    test_s_strncmp();
    test_s_abs();
    test_s_pow();
/* -------------------------------------------------- */
/*  s_strlen                                          */
/* -------------------------------------------------- */
static void test_s_strlen(void)
{
    printf("--- s_strlen ---\n");

    /* cas normaux */
    TEST(s_strlen("Hello") == 5);
    TEST(s_strlen("abc") == 3);
    TEST(s_strlen("a") == 1);

    /* chaîne vide */
    TEST(s_strlen("") == 0);

    /* chaîne avec espaces */
    TEST(s_strlen("hello world") == 11);

    /* chaîne avec caractères spéciaux */
    TEST(s_strlen("a\tb\n") == 4);
}

/* -------------------------------------------------- */
/*  s_strchr                                          */
/* -------------------------------------------------- */
static void test_s_strchr(void)
{
    printf("--- s_strchr ---\n");

    const char *s = "hello world";

    /* caractère présent */
    TEST(s_strchr(s, 'h') == s);      /* premier caractère */
    TEST(s_strchr(s, 'd') == s + 10); /* dernier caractère */
    TEST(s_strchr(s, 'o') == s + 4);  /* première occurrence */
    TEST(s_strchr(s, ' ') == s + 5);  /* espace */

    /* caractère absent */
    TEST(s_strchr(s, 'z') == NULL);
    TEST(s_strchr(s, '!') == NULL);

    /* recherche du \0 terminal : doit retourner pointeur sur \0 */
    const char *end = s_strchr(s, '\0');
    TEST(end != NULL && *end == '\0');
    TEST(end == s + 11);

    /* chaîne vide */
    TEST(s_strchr("", 'a') == NULL);
    TEST(s_strchr("", '\0') != NULL); /* \0 trouvé en position 0 */

    /* premier caractère == c */
    const char *s2 = "abcd";
    TEST(s_strchr(s2, 'a') == s2);
}

/* -------------------------------------------------- */
/*  s_fread / s_fwrite                                */
/* -------------------------------------------------- */
static void test_s_fread_fwrite(void)
{
    printf("--- s_fread / s_fwrite ---\n");

    const char *tmpfile = "/tmp/s_libc_test.tmp";
    const char *msg = "Hello s_libc!";
    size_t msglen = strlen(msg); /* 13 */

    /* --- écriture --- */
    int fd_w = open(tmpfile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    TEST(fd_w >= 0);

    if (fd_w >= 0)
    {
        ssize_t written = s_fwrite(msg, 1, msglen, fd_w);
        TEST((size_t)written == msglen); /* tous les octets écrits */
        close(fd_w);
    }

    /* --- lecture --- */
    int fd_r = open(tmpfile, O_RDONLY);
    TEST(fd_r >= 0);

    if (fd_r >= 0)
    {
        char buf[64];
        memset(buf, 0, sizeof(buf));

        ssize_t nread = s_fread(buf, 1, msglen, fd_r);
        TEST((size_t)nread == msglen);       /* bon nombre d'octets */
        TEST(memcmp(buf, msg, msglen) == 0); /* contenu identique */
        close(fd_r);
    }

    /* --- écriture avec size > 1 --- */
    int fd_w2 = open(tmpfile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    TEST(fd_w2 >= 0);

    if (fd_w2 >= 0)
    {
        /* écrire 3 éléments de 4 octets = 12 octets */
        const char *data = "ABCDEFGHIJKL";
        ssize_t written = s_fwrite(data, 4, 3, fd_w2);
        TEST(written == 12);
        close(fd_w2);
    }

    /* --- lecture avec size > 1 --- */
    int fd_r2 = open(tmpfile, O_RDONLY);
    TEST(fd_r2 >= 0);

    if (fd_r2 >= 0)
    {
        char buf2[64];
        memset(buf2, 0, sizeof(buf2));
        ssize_t nread = s_fread(buf2, 4, 3, fd_r2);
        TEST(nread == 12);
        TEST(memcmp(buf2, "ABCDEFGHIJKL", 12) == 0);
        close(fd_r2);
    }

    /* nettoyage */
    unlink(tmpfile);
}

/* -------------------------------------------------- */
/*  main                                              */
/* -------------------------------------------------- */
int main(void)
{
    printf("=== TEST LIB S_LIBC ===\n\n");

    test_s_strlen();
    test_s_strchr();
    test_s_fread_fwrite();

    printf("\nTests exécutés : %d\n", total_tests);
    printf("Échecs        : %d\n", failed_tests);

    if (failed_tests == 0)
        printf("✅ Tous les tests sont passés\n");
    else
        printf("❌ Certains tests ont échoué\n");

    /* Test bonus : s_exit */
    /* Décommente si tu veux tester la syscall exit */
    /*
    if (failed_tests != 0)
        s_exit(1);
    else
        s_exit(0);
    */

    return failed_tests;
}
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
    return failed_tests;
}