.data
array:  .word  2, 32, 32, 15, 2, 2   # array inicial
n:      .word  6                # tamaño del array
msg0:   .asciiz "Array original:\n"
msg1:   .asciiz "\nArray ordenado:\n"
space:  .asciiz " "

.text
.globl main

main:
    # mostrar array original
    la   $a0, msg0
    li   $v0, 4
    syscall
    
    jal  print_array

    # preparar parametros para ordenamiento
    la   $a0, array        # $a0 = puntero al primer elemento
    la   $a1, array        # $a1 = puntero al último elemento
    lw   $t0, n
    addi $t0, $t0, -1
    sll  $t0, $t0, 2       # (n-1)*4 en bytes
    add  $a1, $a1, $t0     # $a1 = &array[n-1]

sort_loop:
    beq  $a0, $a1, done    # si ya solo queda 1 elemento --> fin

    # llamada a max(array[0..a1])
    jal  max

    # intercambiar valores
    lw   $t1, 0($a1)       # ultimo elemento -> t1
    lw   $t2, 0($v0)       # maximo -> t2
    sw   $t1, 0($v0)       # guardar ultimo en posición del maximo
    sw   $t2, 0($a1)       # guardar maximo en ultima posicion

    addi $a1, $a1, -4      # reducir rango (ultimo--)
    j    sort_loop

done:
    # imprimir mensaje
    la   $a0, msg1
    li   $v0, 4
    syscall

    # imprimir arreglo ordenado
    jal  print_array

end_program:
    li   $v0, 10
    syscall

# Función para imprimir array
print_array:
    la   $t3, array
    lw   $t4, n

print_loop:
    beqz $t4, print_done
    lw   $a0, 0($t3)
    li   $v0, 1
    syscall

    la   $a0, space       # espacio
    li   $v0, 4
    syscall

    addi $t3, $t3, 4      # siguiente elemento
    addi $t4, $t4, -1
    j    print_loop

print_done:
    jr   $ra

max:
    move $t0, $a0       # puntero actual
    lw   $v1, 0($t0)    # valor maximo inicial
    move $v0, $t0       # dirección del maximo inicial

max_loop:
    beq  $t0, $a1, max_done   # si llegamos al ultimo -> fin
    addi $t0, $t0, 4          # avanzar puntero
    lw   $t1, 0($t0)          # leer valor

    ble  $t1, $v1, max_loop   # si t1 <= v1, continuar
    move $v1, $t1             # nuevo maximo
    move $v0, $t0             # nueva direccion

    j    max_loop

max_done:
    jr   $ra