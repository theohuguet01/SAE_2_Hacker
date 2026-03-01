.section .note.GNU-stack,"",@progbits
.section .text
.globl s_strcpy
.globl s_strlen

# ====== s_strlen ======
s_strlen:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %esi
    xorl %eax, %eax

s_strlen_loop:
    movb (%esi,%eax), %dl
    cmpb $0, %dl
    jz s_strlen_end
    incl %eax
    jmp s_strlen_loop

s_strlen_end:
    popl %ebp
    ret

# ====== s_strcpy ======
s_strcpy:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    movl 8(%ebp), %edx
    movl 12(%ebp), %ecx

.copy_loop:
    movb (%ecx), %bl
    movb %bl, (%edx)
    cmpb $0, %bl
    je .copy_done
    incl %ecx
    incl %edx
    jmp .copy_loop

.copy_done:
    movl 8(%ebp), %eax
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret
# ====== s_strncpy ======
.globl s_strncpy
s_strncpy:
    pushl %ebp
    movl %esp, %ebp
    pushl %esi
    pushl %edi
    pushl %ebx

    movl 8(%ebp), %edi        # edi = dest
    movl 12(%ebp), %esi       # esi = src
    movl 16(%ebp), %ecx       # ecx = n
    xorl %edx, %edx           # edx = compteur = 0

.strncpy_copy:
    cmpl %ecx, %edx           # compteur >= n ?
    jge .strncpy_done          # si oui, terminé

    movb (%esi,%edx), %bl      # bl = caractère courant de src
    movb %bl, (%edi,%edx)      # copie dans dest
    incl %edx                  # compteur++

    cmpb $0, %bl               # c'est le '\0' ?
    jne .strncpy_copy          # si non, on continue de copier

.strncpy_pad:
    cmpl %ecx, %edx           # compteur >= n ?
    jge .strncpy_done          # si oui, terminé
    movb $0, (%edi,%edx)       # sinon, remplir avec '\0'
    incl %edx
    jmp .strncpy_pad

.strncpy_done:
    movl 8(%ebp), %eax        # retourne dest
    popl %ebx
    popl %edi
    popl %esi
    movl %ebp, %esp
    popl %ebp
    ret