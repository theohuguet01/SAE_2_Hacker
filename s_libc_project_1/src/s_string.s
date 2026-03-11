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