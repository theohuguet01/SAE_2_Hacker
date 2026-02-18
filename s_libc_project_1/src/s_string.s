.section .note.GNU-stack,"",@progbits
.section .text
.globl s_strcpy

s_strcpy:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx                # sauvegarder ebx

    movl 8(%ebp), %edx        # edx = dest
    movl 12(%ebp), %ecx       # ecx = src

.copy_loop:
    movb (%ecx), %bl           # bl = caractère courant de src
    movb %bl, (%edx)           # copie dans dest
    cmpb $0, %bl               # c'est le '\0' ?
    je .copy_done
    incl %ecx                  # caractère suivant de src
    incl %edx                  # caractère suivant de dest
    jmp .copy_loop

.copy_done:
    movl 8(%ebp), %eax         # retourne dest
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret