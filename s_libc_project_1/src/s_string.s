    .text
    .globl s_strcat
    .type  s_strcat, @function

# char *s_strcat(char *dst, const char *src)

s_strcat:
    pushl %ebp
    movl  %esp, %ebp

    pushl %ebx              # EBX est callee-saved -> on le sauvegarde
    cld                      # direction forward

    movl  8(%ebp), %edi      # EDI = dst
    movl 12(%ebp), %esi      # ESI = src
    movl  8(%ebp), %ebx      # EBX = dst (à retourner)

    xorl  %eax, %eax         # AL = 0 (caractère recherché pour scasb)
    xorl  %ecx, %ecx
    decl  %ecx               # ECX = 0xFFFFFFFF

    repne scasb              # cherche '\0' dans dst
    decl  %edi               # revient sur le '\0' terminal

.L_copy:
    lodsb                    # AL = *src ; src++
    stosb                    # *dst = AL ; dst++
    testb %al, %al
    jne   .L_copy

    movl  %ebx, %eax         # return dst

    popl  %ebx
    popl  %ebp
    ret



     .text
    .globl s_strncat
    .type  s_strncat, @function

# char *s_strncat(char *dst, const char *src, size_t sz)
# dst = 8(%ebp)
# src = 12(%ebp)
# sz  = 16(%ebp)
# return eax = dst

s_strncat:
    pushl %ebp
    movl  %esp, %ebp

    pushl %ebx              # callee-saved
    cld

    movl  8(%ebp), %edi      # EDI = dst (sera avancé)
    movl 12(%ebp), %esi      # ESI = src
    movl  8(%ebp), %ebx      # EBX = dst (retour)
    movl 16(%ebp), %edx      # EDX = sz (on le sauvegarde ici)

    # --- trouver fin de dst: repne scasb cherche '\0' ---
    xorl  %eax, %eax         # AL = 0
    movl  $-1, %ecx          # ECX = 0xFFFFFFFF
    repne scasb
    decl  %edi               # EDI pointe sur '\0' terminal

    # --- restaurer sz dans ECX pour la copie limitée ---
    movl  %edx, %ecx         # ECX = sz

.L_copy_n:
    testl %ecx, %ecx         # sz == 0 ?
    jz    .L_done

    lodsb                    # AL = *src ; src++
    testb %al, %al           # fin src ?
    jz    .L_done

    stosb                    # *dst = AL ; dst++
    decl  %ecx               # sz--
    jmp   .L_copy_n

.L_done:
    movb  $0, (%edi)         # toujours terminer par '\0'
    movl  %ebx, %eax         # return dst

    popl  %ebx
    popl  %ebp
    ret






# Enlever le warning de .GNU-stack
    .section .note.GNU-stack,"",@progbits