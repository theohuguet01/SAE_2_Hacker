################################
####### Fonction s_fopen #######
################################
    .text
    .globl s_fopen
    .type  s_fopen, @function
    .extern fopen

# FILE *s_fopen(const char *pathname, const char *mode)
# args:
#   8(%ebp)  = pathname
#   12(%ebp) = mode
# return:
#   eax = FILE* (ou NULL)

s_fopen:
    pushl %ebp
    movl  %esp, %ebp

    pushl 12(%ebp)          # mode
    pushl 8(%ebp)           # pathname
    call  fopen
    addl  $8, %esp          # clean stack (cdecl)

    popl  %ebp
    ret



###################################
######## Fonction s_fclose ########
###################################
    .text
    .globl s_fclose
    .type  s_fclose, @function
    .extern fclose

# int s_fclose(FILE *stream)
# arg:
#   8(%ebp) = stream
# return:
#   eax = 0 (succès) ou EOF (-1)

s_fclose:
    pushl %ebp
    movl  %esp, %ebp

    pushl 8(%ebp)           # stream
    call  fclose
    addl  $4, %esp           # clean stack

    popl  %ebp
    ret

# Enlever le warning de .GNU-stack
    .section .note.GNU-stack,"",@progbits