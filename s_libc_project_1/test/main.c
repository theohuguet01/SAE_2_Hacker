#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stddef.h>
#include <fcntl.h>
#include <unistd.h>
#include <limits.h>
#include "s_stdio.h"
#include "s_string.h"
#include "s_stdlib.h"
#include "s_math.h"

/* ================================================== */
/*  Macro de test (Dawson / Theo)                     */
/* ================================================== */
static int total_tests = 0;
static int failed_tests = 0;

#define TEST(expr)                              \
    do                                          \
    {                                           \
        total_tests++;                          \
        if (!(expr))                            \
        {                                       \
            failed_tests++;                     \
            printf("[FAIL] %s:%d: %s\n",        \
                   __FILE__, __LINE__, #expr);  \
        }                                       \
    } while (0)

/* ================================================== */
/*  BRANCHE ADAM                                      */
/* ================================================== */
static void test_adam(void)
{
    printf("========================================\n");
    printf("           BRANCHE ADAM\n");
    printf("========================================\n");

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

    printf("\n=== Tous les tests Adam termines ===\n");
}

/* ================================================== */
/*  BRANCHE DAWSON                                    */
/* ================================================== */
static void test_s_strlen_dawson(void)
{
    printf("--- s_strlen ---\n");
    TEST(s_strlen("Hello") == 5);
    TEST(s_strlen("abc") == 3);
    TEST(s_strlen("a") == 1);
    TEST(s_strlen("") == 0);
    TEST(s_strlen("hello world") == 11);
    TEST(s_strlen("a\tb\n") == 4);
}

static void test_s_strchr(void)
{
    printf("--- s_strchr ---\n");
    const char *s = "hello world";
    TEST(s_strchr(s, 'h') == s);
    TEST(s_strchr(s, 'd') == s + 10);
    TEST(s_strchr(s, 'o') == s + 4);
    TEST(s_strchr(s, ' ') == s + 5);
    TEST(s_strchr(s, 'z') == NULL);
    TEST(s_strchr(s, '!') == NULL);
    const char *end = s_strchr(s, '\0');
    TEST(end != NULL && *end == '\0');
    TEST(end == s + 11);
    TEST(s_strchr("", 'a') == NULL);
    TEST(s_strchr("", '\0') != NULL);
    const char *s2 = "abcd";
    TEST(s_strchr(s2, 'a') == s2);
}

static void test_s_fread_fwrite(void)
{
    printf("--- s_fread / s_fwrite ---\n");
    const char *tmpfile = "/tmp/s_libc_test.tmp";
    const char *msg = "Hello s_libc!";
    size_t msglen = strlen(msg);

    int fd_w = open(tmpfile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    TEST(fd_w >= 0);
    if (fd_w >= 0)
    {
        ssize_t written = s_fwrite(msg, 1, msglen, fd_w);
        TEST((size_t)written == msglen);
        close(fd_w);
    }
    int fd_r = open(tmpfile, O_RDONLY);
    TEST(fd_r >= 0);
    if (fd_r >= 0)
    {
        char buf[64];
        memset(buf, 0, sizeof(buf));
        ssize_t nread = s_fread(buf, 1, msglen, fd_r);
        TEST((size_t)nread == msglen);
        TEST(memcmp(buf, msg, msglen) == 0);
        close(fd_r);
    }
    int fd_w2 = open(tmpfile, O_WRONLY | O_CREAT | O_TRUNC, 0644);
    TEST(fd_w2 >= 0);
    if (fd_w2 >= 0)
    {
        const char *data = "ABCDEFGHIJKL";
        ssize_t written = s_fwrite(data, 4, 3, fd_w2);
        TEST(written == 12);
        close(fd_w2);
    }
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
    unlink(tmpfile);
}

static void test_dawson(void)
{
    printf("========================================\n");
    printf("           BRANCHE DAWSON\n");
    printf("========================================\n");
    test_s_strlen_dawson();
    test_s_strchr();
    test_s_fread_fwrite();
}

/* ================================================== */
/*  BRANCHE MATHEO                                    */
/* ================================================== */
static void test_matheo(void)
{
    printf("========================================\n");
    printf("           BRANCHE MATHEO\n");
    printf("========================================\n");

    /* Test s_strcat */
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

    /* Test s_strncat */
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

    /* Test s_div */
    printf("\n---- TEST s_div ----\n");
    {
        int n = -5, d = 3;
        div_t r1 = s_div(n, d);
        div_t r2 = div(n, d);
        printf("s_div: quot=%d rem=%d\n", r1.quot, r1.rem);
        printf("div : quot=%d rem=%d\n", r2.quot, r2.rem);
        printf("match: %s\n", (r1.quot == r2.quot && r1.rem == r2.rem) ? "OK" : "NO");
    }

    /* Test s_fopen / s_fclose */
    printf("\n---- TEST s_fopen / s_fclose ----\n");
    FILE *f = s_fopen("testfile.txt", "w");
    if (!f) {
        perror("s_fopen");
    } else {
        fputs("Hello World !!!\n", f);
        int rc = s_fclose(f);
        printf("s_fclose returned: %d (%s)\n", rc, (rc == 0) ? "OK" : "ERR");
        FILE *g = fopen("testfile.txt", "r");
        if (!g) perror("fopen(read)");
        else {
            char buf[32];
            fgets(buf, sizeof(buf), g);
            printf("read back: %s", buf);
            s_fclose(g);
        }
    }
}

/* ================================================== */
/*  BRANCHE THEO                                      */
/* ================================================== */
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

static void test_theo(void)
{
    printf("========================================\n");
    printf("           BRANCHE THEO\n");
    printf("========================================\n");
    test_s_strcmp();
    test_s_strncmp();
    test_s_abs();
    test_s_pow();
}

/* ================================================== */
/*  MAIN                                              */
/* ================================================== */
int main(void)
{
    printf("=== TEST GLOBAL S_LIBC ===\n\n");

    test_adam();
    printf("\n");
    test_dawson();
    printf("\n");
    test_matheo();
    printf("\n");
    test_theo();

    printf("\n========================================\n");
    printf("Tests avec macro (Dawson + Theo)\n");
    printf("Tests exécutés : %d\n", total_tests);
    printf("Échecs        : %d\n", failed_tests);
    if (failed_tests == 0)
        printf("✅ Tous les tests sont passés\n");
    else
        printf("❌ Certains tests ont échoué\n");
    printf("========================================\n");

    return failed_tests;
}
