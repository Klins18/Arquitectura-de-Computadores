.data
msg_n:    .asciiz "Ingrese el grado del polinomio (n): "
msg_coef: .asciiz "Ingrese coeficiente a"
msg_x:    .asciiz "Ingrese el valor de x (float): "
msg_res:  .asciiz "El resultado P(x) es: "
newline:  .asciiz "\n"
f_zero:   .float 0.0
f_one:    .float 1.0

.text
.globl main
main:
    # pedir grado
    li $v0, 4
    la $a0, msg_n
    syscall

    li $v0, 5
    syscall
    move $s0, $v0        # s0 = n

    # reservar memoria para (n+1) coeficientes (4 bytes cada uno)
    addi $t0, $s0, 1     # t0 = n+1
    li $t1, 4
    mul $a0, $t0, $t1    # a0 = bytes
    li $v0, 9
    syscall
    move $s1, $v0        # s1 = dirección base de coeficientes

    # leer coeficientes (a0..an)
    li $t2, 0            # i = 0
leer_coef:
    bgt $t2, $s0, fin_leer_coef

    li $v0, 4
    la $a0, msg_coef
    syscall

    move $a0, $t2
    li $v0, 1
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 5
    syscall
    sw $v0, 0($s1)       # guardar coeficiente

    addi $s1, $s1, 4     # avanzar puntero
    addi $t2, $t2, 1
    j leer_coef
fin_leer_coef:

    # restaurar base de coeficientes
    addi $t0, $s0, 1
    li $t1, 4
    mul $t1, $t0, $t1    # t1 = 4*(n+1)
    sub $s1, $s1, $t1    # s1 = inicio otra vez

    # leer x (float)
    li $v0, 4
    la $a0, msg_x
    syscall

    li $v0, 6
    syscall
    mov.s $f2, $f0       # f2 = x

    # calcular P(x)
    li $t2, 0            # i = 0
    l.s $f12, f_zero     # f12 = 0.0 (acumulador)

calc_polinomio:
    bgt $t2, $s0, fin_calc

    sll $t3, $t2, 2      # t3 = i * 4 (offset en bytes)
    add $t4, $s1, $t3
    lw $t5, 0($t4)       # cargar coeficiente entero
    mtc1 $t5, $f4
    cvt.s.w $f4, $f4     # f4 = ai (float)

    li $t6, 0
    l.s $f6, f_one       # f6 = 1.0 (para calcular x^i)
potencia:
    bge $t6, $t2, fin_pot
    mul.s $f6, $f6, $f2
    addi $t6, $t6, 1
    j potencia
fin_pot:

    mul.s $f8, $f4, $f6
    add.s $f12, $f12, $f8

    addi $t2, $t2, 1
    j calc_polinomio
fin_calc:

    # imprimir resultado
    li $v0, 4
    la $a0, msg_res
    syscall

    li $v0, 2
    syscall              # imprime float en $f12

    li $v0, 4
    la $a0, newline
    syscall

    li $v0, 10
    syscall
