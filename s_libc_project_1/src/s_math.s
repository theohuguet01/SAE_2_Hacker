##############################
####### Fonction s_div #######
##############################

    .text                           # section contenant le code exécutable
    .globl s_div                    # rend le symbole s_div visible à l'éditeur de liens
    .type  s_div, @function         # indique que s_div est une fonction

s_div:
    pushl %ebp                      # sauvegarde l'ancien pointeur de pile
    movl  %esp, %ebp                # crée le nouveau cadre de pile de la fonction

    # En convention GCC 32 bits avec retour de structure,
    # 8(%ebp)  contient un pointeur caché vers la structure résultat,
    # 12(%ebp) contient numerator,
    # 16(%ebp) contient denominator.

    movl  12(%ebp), %eax            # charge numerator dans EAX
                                     # EAX est utilisé par l'instruction de division

    cdq                             # étend le signe de EAX dans EDX
                                     # après cette instruction, le dividende est dans EDX:EAX
                                     # c'est nécessaire pour une division signée avec idiv

    idivl 16(%ebp)                  # divise EDX:EAX par denominator
                                     # résultat :
                                     # - quotient dans EAX
                                     # - reste dans EDX

    movl  8(%ebp), %ecx             # récupère le pointeur vers la structure résultat
                                     # GCC attend que l'on écrive dedans

    movl  %eax, 0(%ecx)             # écrit le quotient dans result->quot
                                     # le premier champ de la structure est à l'offset 0

    movl  %edx, 4(%ecx)             # écrit le reste dans result->rem
                                     # le second champ est à l'offset 4

    movl  8(%ebp), %eax             # place dans EAX l'adresse de la structure résultat
                                     # c'est la convention GCC pour le retour d'une structure

    popl  %ebp                      # restaure l'ancien cadre de pile
    ret                             # retourne à l'appelant


# Directive ajoutée pour indiquer que ce fichier n'a pas besoin d'une pile exécutable
# Cela supprime le warning .note.GNU-stack à l'édition de liens
    .section .note.GNU-stack,"",@progbits