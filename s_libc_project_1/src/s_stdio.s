.section .text
.globl s_puts

s_puts:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    # récupérer le pointeur de la chaîne
    movl 8(%ebp), %ecx

    # calculer la longueur
    xorl %edx, %edx
.count:
    cmpb $0, (%ecx,%edx,1)
    je .print
    incl %edx
    jmp .count

.print:
    # syscall write(1, chaine, longueur)
    movl $4, %eax
    movl $1, %ebx
    # ecx = adresse de la chaîne
    # edx = longueur
    int $0x80

    # ajouter le '\n'
    pushl $0x0A
    movl $4, %eax
    movl $1, %ebx
    movl %esp, %ecx
    movl $1, %edx
    int $0x80
    addl $4, %esp

    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret

// deuxiéme fonction 
