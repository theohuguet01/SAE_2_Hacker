#################################
####### Fonction s_strcat #######
#################################

    .text                           # section de code
    .globl s_strcat                 # rend la fonction visible hors du fichier
    .type  s_strcat, @function      # précise que s_strcat est une fonction

# char *s_strcat(char *dst, const char *src)
# Convention cdecl en 32 bits :
# 8(%ebp)  = dst
# 12(%ebp) = src

s_strcat:
    pushl %ebp                      # sauvegarde l'ancien pointeur de base : met l’ancienne valeur de EBP sur la pile.
    movl  %esp, %ebp                # crée le cadre de pile de la fonction : copie ESP dans EBP.

    pushl %ebx                      # sauvegarde EBX 
                                     # si on le modifie, on doit le restaurer avant de quitter

    cld                             # met le Direction Flag à 0
                                     # les instructions de chaîne avanceront vers les adresses croissantes

    movl  8(%ebp), %edi             # EDI reçoit dst
                                     # EDI servira de pointeur de destination

    movl 12(%ebp), %esi             # ESI reçoit src
                                     # ESI servira de pointeur source

    movl  8(%ebp), %ebx             # sauvegarde dst dans EBX
                                     # on en aura besoin pour la valeur de retour finale

    xorl  %eax, %eax                # met EAX à 0
                                     # AL = 0, donc on prépare la recherche du caractère '\0'

    xorl  %ecx, %ecx                # met ECX à 0
    decl  %ecx                      # ECX devient 0xFFFFFFFF
                                     # on utilise ECX comme très grand compteur pour repne scasb

    repne scasb                     # parcourt dst octet par octet à partir de EDI
                                     # compare AL (ici 0) avec chaque octet
                                     # s'arrête lorsqu'il trouve le '\0' terminal

    decl  %edi                      # scasb a avancé EDI après le '\0'
                                     # on revient donc sur le '\0' pour l'écraser

.L_copy:
    lodsb                           # charge l'octet pointé par ESI dans AL puis incrémente ESI
                                     # cela lit le caractère courant de src

    stosb                           # écrit AL à l'adresse pointée par EDI puis incrémente EDI
                                     # cela copie le caractère dans dst

    testb %al, %al                  # teste si le caractère copié est nul
                                     # si AL == 0, on a atteint la fin de src

    jne   .L_copy                   # si AL n'est pas nul, on continue la copie

    movl  %ebx, %eax                # place dst dans EAX
                                     # strcat doit retourner le pointeur dst

    popl  %ebx                      # restaure EBX
    popl  %ebp                      # restaure le cadre de pile précédent
    ret                             # retour à l'appelant




##################################
####### Fonction s_strncat #######
##################################

    .text                           # section de code exécutable
    .globl s_strncat                # exporte la fonction
    .type  s_strncat, @function     # indique qu'il s'agit d'une fonction

# char *s_strncat(char *dst, const char *src, size_t sz)
# Convention cdecl :
# 8(%ebp)  = dst
# 12(%ebp) = src
# 16(%ebp) = sz

s_strncat:
    pushl %ebp                      # sauvegarde l'ancien pointeur de base
    movl  %esp, %ebp                # crée le cadre de pile

    pushl %ebx                      # sauvegarde EBX

    cld                             # met la direction vers l'avant pour les instructions de chaîne

    movl  8(%ebp), %edi             # EDI = dst
                                     # EDI servira à parcourir puis écrire dans dst

    movl 12(%ebp), %esi             # ESI = src
                                     # ESI servira à lire les caractères de src

    movl  8(%ebp), %ebx             # EBX = dst
                                     # on garde la valeur initiale de dst pour la retourner à la fin

    movl 16(%ebp), %edx             # EDX = sz
                                     # on sauvegarde la limite de copie dans EDX

    # Recherche de la fin de dst pour savoir où commencer la concaténation
    xorl  %eax, %eax                # EAX = 0 donc AL = '\0'
    movl  $-1, %ecx                 # ECX = 0xFFFFFFFF, compteur très grand
    repne scasb                     # cherche le '\0' terminal dans dst
    decl  %edi                      # revient sur le '\0' trouvé pour le remplacer

    # Réutilisation de sz comme compteur de boucle de copie
    movl  %edx, %ecx                # ECX = sz
                                     # ECX va maintenant compter combien de caractères on peut encore copier

.L_copy_n:
    testl %ecx, %ecx                # teste si sz vaut 0
    jz    .L_done                   # si oui, on arrête la copie

    lodsb                           # lit un caractère de src dans AL et avance ESI
    testb %al, %al                  # teste si on vient de lire '\0'
    jz    .L_done                   # si oui, src est terminé, on arrête

    stosb                           # copie le caractère dans dst et avance EDI
    decl  %ecx                      # décrémente le nombre de caractères restants
    jmp   .L_copy_n                 # recommence la boucle

.L_done:
    movb  $0, (%edi)                # écrit explicitement le '\0' final
                                     # s_strncat doit toujours terminer la chaîne résultante

    movl  %ebx, %eax                # place dst dans EAX
                                     # valeur de retour attendue de strncat

    popl  %ebx                      # restaure EBX
    popl  %ebp                      # restaure l'ancien cadre de pile
    ret                             # retourne à l'appelant


# Supprime le warning lié à la pile exécutable
    .section .note.GNU-stack,"",@progbits