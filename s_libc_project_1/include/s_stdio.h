#ifndef S_STDIO_H
#define S_STDIO_H

#include <stddef.h>
#include <sys/types.h> /* ssize_t */

/*
 * Note : s_fread et s_fwrite opèrent sur un file descriptor (int fd)
 * et non sur un FILE*, conformément à l'implémentation assembleur
 * basée sur les syscalls Linux read(2) et write(2).
 */

extern ssize_t s_fread(void *buf, size_t size, size_t count, int fd);
extern ssize_t s_fwrite(const void *buf, size_t size, size_t count, int fd);

#endif /* S_STDIO_H */