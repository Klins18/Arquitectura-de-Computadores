.text
.globl __start
__start:
    # Imprimir cadena original
    la $a0, prm1
    li $v0, 4
    syscall
    la $a0, orig
    li $v0, 4
    syscall

    la $s0, orig          # puntero a cadena
    li $t2, 1             # flag: inicio de palabra
    li $t6, 0x20          # ASCII ' '
    li $t7, 0x61          # ASCII 'a'
    li $t8, 0x7a          # ASCII 'z'

loop:                     
    lb $t1, 0($s0)        # cargar caracter
    beq $t1, $zero, endLoop  # fin de cadena

    # verificar si es minúscula
    slt $t3, $t1, $t7     # t3=1 si c < 'a'
    slt $t4, $t8, $t1     # t4=1 si c > 'z'
    or  $t3, $t3, $t4     # t3=0 si está en rango 'a'..'z'

    # si estamos en inicio y es minúscula -> convertir
    beq $t2, $zero, nospace
    bne $t3, $zero, nospace
    addi $t1, $t1, -32    # convertir a mayúscula
    sb $t1, 0($s0)

nospace:
    # actualizar flag según espacio
    bne $t1, $t6, notspace
    li $t2, 1             # próximo es inicio
    j endcheck
notspace:
    li $t2, 0
endcheck:
    addi $s0, $s0, 1      # avanzar
    j loop

endLoop:
    # imprimir cadena modificada
    la $a0, prm2
    li $v0, 4
    syscall
    la $a0, orig
    li $v0, 4
    syscall

    # salir
    li $v0, 10
    syscall

.data
orig: .asciiz "la cadena original con letras todas minusculas"
prm1: .asciiz "Original: "
prm2: .asciiz "\nUpcased : "
