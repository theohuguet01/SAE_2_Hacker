    .text

    .globl s_abs
    .type  s_abs, @function
s_abs:
    pushl %ebp
    movl  %esp, %ebp

    movl  8(%ebp), %eax      # Charger le paramètre n
    cmpl  $0, %eax
    jge   .Labs_end          # Si n >= 0, retourner n

    # Cas spécial : si n == INT_MIN, -n causerait un débordement
    # On retourne INT_MIN tel quel
    cmpl  $0x80000000, %eax
    je    .Labs_end

    negl  %eax               # Calculer -n
.Labs_end:
    popl  %ebp
    ret


    .globl s_pow
    .type  s_pow, @function
s_pow:
    pushl %ebp
    movl  %esp, %ebp
    subl  $16, %esp          # espace local (alignement simple + stockage base)

    # Stocker base (double) localement pour pouvoir le recharger
    movl  8(%ebp), %eax
    movl  %eax, -8(%ebp)
    movl 12(%ebp), %eax
    movl  %eax, -4(%ebp)

    movl 16(%ebp), %ecx      # exp

    # Si exp == 0 => 1.0
    testl %ecx, %ecx
    jne   .Lpow_check_sign
    fld1                      # st0 = 1.0
    jmp   .Lpow_end

.Lpow_check_sign:
    # result = 1.0
    fld1                      # st0 = result

    cmpl  $0, %ecx
    jge   .Lpow_loop_pos

    # exp négatif : travailler sur |exp| puis faire 1/result
    negl  %ecx                # ecx = -exp

.Lpow_loop_neg:
    testl %ecx, %ecx
    je    .Lpow_finish_neg
    fldl  -8(%ebp)            # st0=base, st1=result
    fmulp %st, %st(1)         # result *= base ; pop => st0=result
    decl  %ecx
    jmp   .Lpow_loop_neg

.Lpow_finish_neg:
    # À ce point : st0 = result (= base^|exp|)
    # On veut : 1.0 / result (sans ambiguïté d’ordre)

    fstpl -16(%ebp)          # stocke result (double) en mémoire et pop
    fld1                      # st0 = 1.0
    fdivl -16(%ebp)          # st0 = st0 / mem = 1.0 / result
    jmp   .Lpow_end

.Lpow_loop_pos:
    testl %ecx, %ecx
    je    .Lpow_end
    fldl  -8(%ebp)            # st0=base, st1=result
    fmulp %st, %st(1)         # result *= base ; pop => st0=result
    decl  %ecx
    jmp   .Lpow_loop_pos

.Lpow_end:
    leave
    ret
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