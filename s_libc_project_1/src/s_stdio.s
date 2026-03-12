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
.text

.global s_fread
s_fread:
    # Prologue de la fonction
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %ebx

    # Charger les paramètres depuis la pile
    movl    8(%ebp),  %ecx    # buffer (adresse mémoire)
    movl    12(%ebp), %eax    # taille à lire
    movl    16(%ebp), %edx    # nombre d'éléments
    mull    %edx              # calculer taille_totale = taille * nombre
    movl    %eax, %edx        # mettre le résultat dans %edx

    # Appel système read
    movl    20(%ebp), %ebx    # file descriptor
    movl    $3, %eax          # syscall read (3)
    int     $0x80             # interruption système

    # Épilogue
    popl    %ebx
    popl    %ebp
    ret


.global s_fwrite
s_fwrite:
    # Prologue de la fonction
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %ebx

    # Charger les paramètres depuis la pile
    movl    8(%ebp),  %ecx    # buffer (adresse mémoire)
    movl    12(%ebp), %eax    # taille à écrire
    movl    16(%ebp), %edx    # nombre d'éléments
    mull    %edx              # calculer taille_totale = taille * nombre
    movl    %eax, %edx        # mettre le résultat dans %edx

    # Appel système write
    movl    20(%ebp), %ebx    # file descriptor
    movl    $4, %eax          # syscall write (4)
    int     $0x80             # interruption système

    # Épilogue
    popl    %ebx
    popl    %ebp
    ret
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