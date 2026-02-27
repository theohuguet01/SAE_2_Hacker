    .text

    .globl s_exit
    .type  s_exit, @function
s_exit:
    pushl %ebp
    movl  %esp, %ebp

    movl  8(%ebp), %ebx      # status
    movl  $1, %eax           # sys_exit (Linux i386)
    int   $0x80

    # Normalement unreachable
    hlt
    popl  %ebp
    ret
