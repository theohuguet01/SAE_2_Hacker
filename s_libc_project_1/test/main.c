#include <stdio.h>
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

    return failed_tests;
}