.text

.global s_strlen
s_strlen:
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %esi

    movl    8(%ebp), %esi
    xorl    %eax, %eax

.s_strlen_loop:
    movb    (%esi, %eax), %dl
    cmpb    $0, %dl
    je      .s_strlen_end
    incl    %eax
    jmp     .s_strlen_loop

.s_strlen_end:
    popl    %esi
    popl    %ebp
    ret


.global s_strchr
s_strchr:
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %esi

    movl    8(%ebp), %esi
    movb    12(%ebp), %cl

.s_strchr_loop:
    movb    (%esi), %dl
    cmpb    %cl, %dl
    je      .s_strchr_found
    cmpb    $0, %dl
    je      .s_strchr_notfound
    incl    %esi
    jmp     .s_strchr_loop

.s_strchr_found:
    movl    %esi, %eax
    jmp     .s_strchr_end

.s_strchr_notfound:
    xorl    %eax, %eax

.s_strchr_end:
    popl    %esi
    popl    %ebp
    ret