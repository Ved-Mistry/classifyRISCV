.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
#   a0 (int*) is the pointer to the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   None
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# ==============================================================================
relu:
    addi t0 x0 0
    add t1 a0 x0
    bgt a1 x0 loop_start
    li a0 36
    j exit
    
loop_start:
    lw t2 0(t1)
    blt t2 x0 loop_continue
    j loop_end

loop_continue:
    sw x0 0(t1)
    j loop_end
    
loop_end:
    addi t0 t0 1
    addi t1 t1 4
    ble a1 t0 done
    j loop_start

done:
    jr ra
