.section .note.GNU-stack,"",@progbits

.text

# ============================================
# int s_strlen(char *str)
# Retourne la longueur de la chaîne str
# ============================================
.global s_strlen
s_strlen:
    pushl %ebp
    movl %esp, %ebp
    movl 8(%ebp), %esi       # adresse de début de la chaîne
    xorl %eax, %eax          # compteur = 0
s_strlen_loop:
    movb (%esi,%eax), %dl     # charger le caractère courant
    cmpb $0, %dl              # est-ce le '\0' ?
    jz s_strlen_end           # si oui, on a fini
    incl %eax                 # sinon, compteur++
    jmp s_strlen_loop
s_strlen_end:
    pop %ebp
    ret

# ============================================
# char *s_strcpy(char *dest, const char *src)
# TODO: à implémenter
# ============================================

# ============================================
# char *s_strncpy(char *dest, const char *src, int n)
# TODO: à implémenter
# ============================================

# ============================================
# char *s_strcat(char *dest, const char *src)
# TODO: à implémenter
# ============================================

# ============================================
# char *s_strncat(char *dest, const char *src, int n)
# TODO: à implémenter
# ============================================

# ============================================
# int s_strcmp(const char *s1, const char *s2)
# TODO: à implémenter
# ============================================

# ============================================
# int s_strncmp(const char *s1, const char *s2, int n)
# TODO: à implémenter
# ============================================

# ============================================
# char *s_strchr(const char *s, int c)
# TODO: à implémenter
# ============================================
