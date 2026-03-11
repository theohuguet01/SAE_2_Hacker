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
