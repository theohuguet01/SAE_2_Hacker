#ifndef S_STRING_H
#define S_STRING_H

#include <stddef.h> /* size_t */

int s_strcmp(const char *s1, const char *s2);
int s_strncmp(const char *s1, const char *s2, size_t n);

#endif /* S_STRING_H */
int s_strlen(const char *str);
char* s_strcpy(char *dest, const char *src);
char* s_strncpy(char *dest, const char *src, int n);

#endif
#include <stddef.h>

extern size_t s_strlen(const char *s);
extern char *s_strchr(const char *s, int c);

#endif /* S_STRING_H */