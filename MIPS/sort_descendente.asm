.data
array:  .word  25, 17, 31, 13, 2   # array inicial
n:      .word  5                   # tamaño del array
msg0:   .asciiz "Array original:\n"
msg1:   .asciiz "\nArray ordenado (descendente):\n"
space:  .asciiz " "

.text
.globl main

main:
    # imprimir array original
    la   $a0, msg0
    li   $v0, 4
    syscall
    
    jal  print_array

    # punteros a inicio y fin
    la   $a0, array        # $a0 = inicio
    la   $a1, array        # $a1 = fin
    lw   $t0, n
    addi $t0, $t0, -1
    sll  $t0, $t0, 2       # (n-1)*4 bytes
    add  $a1, $a1, $t0     # $a1 = &array[n-1]

desc_sort_loop:
    beq  $a0, $a1, done    # si inicio == fin, fin

    jal  max

    # intercambiar valores
    lw   $t1, 0($a0)       # guardar primer elemento en t1
    lw   $t2, 0($v0)       # guardar MAXIMO en t2
    sw   $t1, 0($v0)       # copiar primer elem en posición del maximo
    sw   $t2, 0($a0)       # copiar MAXIMO en primera posicion

    addi $a0, $a0, 4       # avanzar inicio (inicio++)
    j    desc_sort_loop

done:
    # imprimir mensaje
    la   $a0, msg1
    li   $v0, 4
    syscall

    # imprimir array ordenado
    jal  print_array

end_program:
    li   $v0, 10
    syscall

#imprimir array
print_array:
    la   $t3, array
    lw   $t4, n

print_loop:
    beqz $t4, print_done
    lw   $a0, 0($t3)
    li   $v0, 1
    syscall

    la   $a0, space        # espacio
    li   $v0, 4
    syscall

    addi $t3, $t3, 4       # siguiente elemento
    addi $t4, $t4, -1
    j    print_loop

print_done:
    jr   $ra

max:
    move $t0, $a0       # puntero actual
    lw   $v1, 0($t0)    # valor máximo inicial
    move $v0, $t0       # dirección del máximo inicial

max_loop:
    beq  $t0, $a1, max_done   # si llegamos al último -> fin
    addi $t0, $t0, 4          # avanzar puntero
    lw   $t1, 0($t0)          # leer valor

    ble  $t1, $v1, max_loop   # si t1 <= v1, continuar
    move $v1, $t1             # nuevo máximo
    move $v0, $t0             # nueva dirección

    j    max_loop

max_done:
    jr   $ra