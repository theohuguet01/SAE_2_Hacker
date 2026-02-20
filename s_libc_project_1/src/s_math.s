##############################
####### Fonction s_div #######
##############################
    .text
    .globl s_div
    .type  s_div, @function

# div_t s_div(int numerator, int denominator)
#
# i386 GCC ABI (struct return possible via sret):
#   8(%ebp)  = pointeur caché vers div_t (où écrire quot/rem)
#   12(%ebp) = numerator
#   16(%ebp) = denominator
#
# on doit remplir:
#   result->quot = eax
#   result->rem  = edx
# et retourner le pointeur sret dans eax.

s_div:
    pushl %ebp
    movl  %esp, %ebp

    movl  12(%ebp), %eax     # numerator
    cdq                      # EDX:EAX = sign-extend(numerator)
    idivl 16(%ebp)           # EAX=quot, EDX=rem

    movl  8(%ebp), %ecx      # ECX = result (sret pointer)
    movl  %eax, 0(%ecx)      # result->quot
    movl  %edx, 4(%ecx)      # result->rem

    movl  8(%ebp), %eax      # return sret pointer (convention GCC)

    popl  %ebp
    ret



# Enlever le warning de .GNU-stack
    .section .note.GNU-stack,"",@progbits