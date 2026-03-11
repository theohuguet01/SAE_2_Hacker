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