    .text

    .globl s_strcmp
    .type  s_strcmp, @function
s_strcmp:
    pushl %ebp
    movl  %esp, %ebp

    movl  8(%ebp), %esi      # Charger le pointeur vers s1
    movl 12(%ebp), %edi      # Charger le pointeur vers s2

    # Gérer les pointeurs NULL
    testl %esi, %esi
    jnz   .Lstrcmp_s1_ok
    testl %edi, %edi
    jnz   .Lstrcmp_s1_null_s2_nonnull
    xorl  %eax, %eax         # Les deux NULL => retourner 0
    jmp   .Lstrcmp_end
.Lstrcmp_s1_null_s2_nonnull:
    movl  $-1, %eax          # s1 NULL, s2 non-NULL => retourner -1
    jmp   .Lstrcmp_end
.Lstrcmp_s1_ok:
    testl %edi, %edi
    jnz   .Lstrcmp_loop
    movl  $1, %eax           # s1 non-NULL, s2 NULL => retourner 1
    jmp   .Lstrcmp_end

.Lstrcmp_loop:
    movzbl (%esi), %eax      # Charger le caractère non signé de s1
    movzbl (%edi), %edx      # Charger le caractère non signé de s2
    cmpl   %edx, %eax
    jne    .Lstrcmp_diff
    testl  %eax, %eax        # Vérifier si on a atteint le terminateur nul
    je     .Lstrcmp_equal    # Égal si terminateur nul trouvé
    incl   %esi              # Passer au caractère suivant de s1
    incl   %edi              # Passer au caractère suivant de s2
    jmp    .Lstrcmp_loop

.Lstrcmp_diff:
    subl  %edx, %eax         # Retourner la différence (s1 - s2)
    jmp   .Lstrcmp_end

.Lstrcmp_equal:
    xorl  %eax, %eax         # Retourner 0 pour les chaînes égales

.Lstrcmp_end:
    popl  %ebp
    ret


    .globl s_strncmp
    .type  s_strncmp, @function
s_strncmp:
    pushl %ebp
    movl  %esp, %ebp

    movl  8(%ebp), %esi      # s1
    movl 12(%ebp), %edi      # s2
    movl 16(%ebp), %ecx      # n (size_t en 32-bit ici)

    # Si n == 0 => 0
    testl %ecx, %ecx
    jne   .Lstrncmp_nullcheck
    xorl  %eax, %eax
    jmp   .Lstrncmp_end

.Lstrncmp_nullcheck:
    # Gestion NULL (comportement défini)
    testl %esi, %esi
    jnz   .Lstrncmp_s1_ok
    testl %edi, %edi
    jnz   .Lstrncmp_s1_null_s2_nonnull
    xorl  %eax, %eax         # NULL vs NULL => 0
    jmp   .Lstrncmp_end
.Lstrncmp_s1_null_s2_nonnull:
    movl  $-1, %eax
    jmp   .Lstrncmp_end
.Lstrncmp_s1_ok:
    testl %edi, %edi
    jnz   .Lstrncmp_loop
    movl  $1, %eax           # non-NULL vs NULL => +1
    jmp   .Lstrncmp_end

.Lstrncmp_loop:
    # boucle tant que n > 0
    testl %ecx, %ecx
    je    .Lstrncmp_equal

    movzbl (%esi), %eax
    movzbl (%edi), %edx
    cmpl   %edx, %eax
    jne    .Lstrncmp_diff

    testl  %eax, %eax        # si char == 0 => égalité (jusqu'ici)
    je     .Lstrncmp_equal

    incl  %esi
    incl  %edi
    decl  %ecx
    jmp   .Lstrncmp_loop

.Lstrncmp_diff:
    subl  %edx, %eax         # a - b
    jmp   .Lstrncmp_end

.Lstrncmp_equal:
    xorl  %eax, %eax

.Lstrncmp_end:
    popl  %ebp
    ret
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