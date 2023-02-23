.globl argmax

.text
# =================================================================
# FUNCTION: Given a int array, return the index of the largest
#   element. If there are multiple, return the one
#   with the smallest index.
# Arguments:
#   a0 (int*) is the pointer to the start of the array
#   a1 (int)  is the # of elements in the array
# Returns:
#   a0 (int)  is the first index of the largest element
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
# =================================================================
argmax:
    add t0 x0 x0
    add t1 x0 x0
    lw t3 0(a0)
    bgt a1 x0 loop_start
    li a0 36
    j exit
    
loop_start:
    lw t2 0(a0)
    bgt t2 t3 loop_continue
    j loop_end

loop_continue:
    add t1 t0 x0
    add t3 t2 x0
    j loop_end
    
loop_end:
    addi t0 t0 1
    addi a0 a0 4
    ble a1 t0 done
    j loop_start

done:
    add a0 t1 x0
    jr ra