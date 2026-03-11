#ifndef S_STDIO_H
#define S_STDIO_H

#include <stddef.h>
#include <sys/types.h> /* ssize_t */

extern ssize_t s_fread(void *buf, size_t size, size_t count, int fd);
extern ssize_t s_fwrite(const void *buf, size_t size, size_t count, int fd);

#endif /* S_STDIO_H */