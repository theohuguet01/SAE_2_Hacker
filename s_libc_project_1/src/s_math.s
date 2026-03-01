.section .note.GNU-stack,"",@progbits
.section .text
.globl s_exp

# double s_exp(double x)
# Calcule e^x en utilisant la série de Taylor :
# e^x = 1 + x/1! + x²/2! + x³/3! + ...
s_exp:
    pushl %ebp
    movl %esp, %ebp

    fldl 8(%ebp)              # charge x sur la pile FPU (ST0 = x)

    fld1                       # ST0 = 1.0 (résultat), ST1 = x
    fld1                       # ST0 = 1.0 (terme courant), ST1 = résultat, ST2 = x
    fld1                       # ST0 = 1.0 (compteur n), ST1 = terme, ST2 = résultat, ST3 = x

    movl $20, %ecx            # 20 itérations (précision suffisante)

.exp_loop:
    # terme = terme * x / n
    fld %st(1)                 # copie terme → ST0
    fmul %st(4)                # ST0 = terme * x
    fdiv %st(1)                # ST0 = terme * x / n
    fstp %st(2)                # stocke dans terme, pop

    # résultat = résultat + terme
    fld %st(1)                 # copie terme
    faddp %st(0), %st(3)      # résultat += terme

    # n = n + 1
    fld1
    faddp %st(0), %st(1)      # n++

    decl %ecx
    jnz .exp_loop

    # Nettoyage : on veut juste le résultat
    fstp %st(0)                # pop n
    fstp %st(0)                # pop terme
    # ST0 = résultat → c'est la valeur de retour pour un double

    movl %ebp, %esp
    popl %ebp
    ret