    .text
    .globl s_fopen
    .type  s_fopen, @function
    .extern fopen

# FILE *s_fopen(const char *pathname, const char *mode)
# args:
#   8(%ebp)  = pathname
#   12(%ebp) = mode
# return:
#   eax = FILE* (ou NULL)

s_fopen:
    pushl %ebp
    movl  %esp, %ebp

    pushl 12(%ebp)          # mode
    pushl 8(%ebp)           # pathname
    call  fopen
    addl  $8, %esp          # clean stack (cdecl)

    popl  %ebp
    ret

    .section .note.GNU-stack,"",@progbits
