################################
####### Fonction s_fopen #######
################################

    .text                           # section de code
    .globl s_fopen                  # exporte le symbole s_fopen
    .type  s_fopen, @function       # indique que c'est une fonction
    .extern fopen                   # déclare que fopen est une fonction externe fournie par la libc

# FILE *s_fopen(const char *pathname, const char *mode)
# Convention cdecl :
# 8(%ebp)  = pathname
# 12(%ebp) = mode
# valeur de retour dans EAX : pointeur FILE* ou NULL

s_fopen:
    pushl %ebp                      # sauvegarde l'ancien cadre de pile
    movl  %esp, %ebp                # crée le nouveau cadre de pile

    pushl 12(%ebp)                  # empile le second argument : mode
                                     # en convention cdecl, les arguments sont poussés de droite à gauche

    pushl 8(%ebp)                   # empile le premier argument : pathname

    call  fopen                     # appelle la vraie fonction fopen de la libc
                                     # fopen retourne un FILE* dans EAX

    addl  $8, %esp                  # nettoie la pile après l'appel
                                     # on enlève les 2 arguments poussés (2 x 4 octets)

    popl  %ebp                      # restaure l'ancien cadre de pile
    ret                             # retourne à l'appelant avec le résultat dans EAX




    ###################################
######## Fonction s_fclose ########
###################################

    .text                           # section contenant le code
    .globl s_fclose                 # exporte la fonction
    .type  s_fclose, @function      # précise qu'il s'agit d'une fonction
    .extern fclose                  # déclare fclose comme fonction externe de la libc

# int s_fclose(FILE *stream)
# Convention cdecl :
# 8(%ebp) = stream
# valeur de retour dans EAX :
# 0 en cas de succès, EOF (-1) en cas d'erreur

s_fclose:
    pushl %ebp                      # sauvegarde l'ancien pointeur de base
    movl  %esp, %ebp                # crée le cadre de pile de la fonction

    pushl 8(%ebp)                   # empile l'argument stream
                                     # il sera passé à fclose

    call  fclose                    # appelle la vraie fonction fclose de la libc
                                     # le code de retour est placé dans EAX

    addl  $4, %esp                  # nettoie la pile après l'appel
                                     # on enlève l'argument empilé (4 octets)

    popl  %ebp                      # restaure l'ancien cadre de pile
    ret                             # retourne à l'appelant avec le résultat dans EAX


# Supprime le warning .GNU-stack
    .section .note.GNU-stack,"",@progbits