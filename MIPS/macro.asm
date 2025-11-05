# Macro para branch if less than
.macro blt (%rs, %rt, %label)
    slt $at, %rs, %rt
    bne $at, $zero, %label
.end_macro

# Macro para branch if greater than  
.macro bgt (%rs, %rt, %label)
    slt $at, %rt, %rs
    bne $at, $zero, %label
.end_macro

# Macro para branch if less or equal
.macro ble (%rs, %rt, %label)
    slt $at, %rt, %rs
    beq $at, $zero, %label
.end_macro

# Macro para branch if greater or equal
.macro bge (%rs, %rt, %label)
    slt $at, %rs, %rt
    beq $at, $zero, %label
.end_macro
