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
