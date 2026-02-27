#include <stdio.h>
#include <limits.h>

#include "../include/s_string.h"
#include "../include/s_math.h"
#include "../include/s_stdlib.h"

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
