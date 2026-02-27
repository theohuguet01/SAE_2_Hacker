    .text

    .globl s_abs
    .type  s_abs, @function
s_abs:
    pushl %ebp
    movl  %esp, %ebp

    movl  8(%ebp), %eax      # n
    cmpl  $0, %eax
    jge   .Labs_end          # n >= 0 => return n

    # si n == INT_MIN, -n overflow => on retourne INT_MIN tel quel (choix défini)
    cmpl  $0x80000000, %eax
    je    .Labs_end

    negl  %eax               # -n
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
