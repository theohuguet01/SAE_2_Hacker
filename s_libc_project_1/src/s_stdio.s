.text

.global s_fread
s_fread:
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %ebx

    movl    8(%ebp),  %ecx
    movl    12(%ebp), %eax
    movl    16(%ebp), %edx
    mull    %edx
    movl    %eax, %edx

    movl    20(%ebp), %ebx
    movl    $3, %eax
    int     $0x80

    popl    %ebx
    popl    %ebp
    ret


.global s_fwrite
s_fwrite:
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %ebx

    movl    8(%ebp),  %ecx
    movl    12(%ebp), %eax
    movl    16(%ebp), %edx
    mull    %edx
    movl    %eax, %edx

    movl    20(%ebp), %ebx
    movl    $4, %eax
    int     $0x80

    popl    %ebx
    popl    %ebp
    ret