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
.text

.global s_strlen
s_strlen:
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %esi

    movl    8(%ebp), %esi          # Charger l'adresse de la string
    xorl    %eax, %eax             # Initialiser le compteur à 0

.s_strlen_loop:
    movb    (%esi, %eax), %dl      # Charger le caractère courant
    cmpb    $0, %dl                # Vérifier si c'est le caractère nul
    je      .s_strlen_end          # Si oui, terminer
    incl    %eax                   # Incrémenter le compteur
    jmp     .s_strlen_loop         # Continuer la boucle

.s_strlen_end:
    popl    %esi
    popl    %ebp
    ret


.global s_strchr
s_strchr:
    pushl   %ebp
    movl    %esp, %ebp
    pushl   %esi

    movl    8(%ebp), %esi          # Charger l'adresse de la string
    movb    12(%ebp), %cl          # Charger le caractère à chercher

.s_strchr_loop:
    movb    (%esi), %dl            # Charger le caractère courant
    cmpb    %cl, %dl               # Comparer avec le caractère cherché
    je      .s_strchr_found        # Si égal, on l'a trouvé
    cmpb    $0, %dl                # Vérifier si fin de string
    je      .s_strchr_notfound     # Si oui, non trouvé
    incl    %esi                   # Passer au caractère suivant
    jmp     .s_strchr_loop         # Continuer la boucle

.s_strchr_found:
    movl    %esi, %eax             # Retourner le pointeur
    jmp     .s_strchr_end

.s_strchr_notfound:
    xorl    %eax, %eax             # Retourner NULL

.s_strchr_end:
    popl    %esi
    popl    %ebp
    ret
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

    pushl %ebx                      # sauvegarde EBX car c'est un registre callee-saved

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