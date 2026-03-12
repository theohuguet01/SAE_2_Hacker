    .text

    .globl s_exit
    .type  s_exit, @function
s_exit:
    # Prologue : sauvegarde du pointeur de base
    pushl %ebp
    movl  %esp, %ebp

    # Charge le code de retour depuis le paramètre (position 8)
    movl  8(%ebp), %ebx
    # Charge le numéro d'appel système exit
    movl  $1, %eax
    # Effectue l'appel système pour terminer le programme
    int   $0x80

    # Stop (point d'arrêt, ne doit pas être atteint)
    hlt
    popl  %ebp
    ret
.section .note.GNU-stack,"",@progbits
.section .text
.globl s_atoi

# int s_atoi(const char *str)
# Convertit une chaîne en entier
s_atoi:
    pushl %ebp
    movl %esp, %ebp
    pushl %ebx

    movl 8(%ebp), %esi        # esi = adresse de la chaîne
    xorl %eax, %eax           # eax = résultat = 0
    xorl %ecx, %ecx           # ecx = signe (0 = positif)
    xorl %edx, %edx           # edx pour le caractère courant

    # Vérifier le signe
    movb (%esi), %dl           # premier caractère
    cmpb $45, %dl              # c'est '-' ? (code ASCII 45)
    jne .atoi_check_plus
    movl $1, %ecx              # ecx = 1 → négatif
    incl %esi                  # avancer après le '-'
    jmp .atoi_loop

.atoi_check_plus:
    cmpb $43, %dl              # c'est '+' ? (code ASCII 43)
    jne .atoi_loop             # si non, on passe directement à la boucle
    incl %esi                  # avancer après le '+'

.atoi_loop:
    movb (%esi), %dl           # dl = caractère courant
    cmpb $48, %dl              # < '0' ? (code ASCII 48)
    jl .atoi_end
    cmpb $57, %dl              # > '9' ? (code ASCII 57)
    jg .atoi_end

    # résultat = résultat * 10 + chiffre
    imull $10, %eax            # eax = eax * 10
    subb $48, %dl              # convertir ASCII → chiffre (dl - '0')
    movzbl %dl, %ebx           # étendre dl sur 32 bits dans ebx
    addl %ebx, %eax            # eax = eax + chiffre

    incl %esi                  # caractère suivant
    jmp .atoi_loop

.atoi_end:
    cmpl $1, %ecx              # signe négatif ?
    jne .atoi_done
    negl %eax                  # eax = -eax

.atoi_done:
    popl %ebx
    movl %ebp, %esp
    popl %ebp
    ret