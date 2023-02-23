.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int arrays
# Arguments:
#   a0 (int*) is the pointer to the start of arr0
#   a1 (int*) is the pointer to the start of arr1
#   a2 (int)  is the number of elements to use
#   a3 (int)  is the stride of arr0
#   a4 (int)  is the stride of arr1
# Returns:
#   a0 (int)  is the dot product of arr0 and arr1
# Exceptions:
#   - If the length of the array is less than 1,
#     this function terminates the program with error code 36
#   - If the stride of either array is less than 1,
#     this function terminates the program with error code 37
# =======================================================
dot:
    ble a2 x0 err
    ble a3 x0 err2 
    ble a4 x0 err2
    addi t0 x0 4
    add t4 x0 x0
    mul t5 a3 t0
    mul t6 a4 t0
    add t0 x0 x0
    j loop_start

err:
    li a0 36
    j exit

err2:
    li a0 37
    j exit
    
loop_start:
    lw t1 0(a0)
    lw t2 0(a1)
    mul t3 t1 t2
    add t4 t4 t3
    addi t0 t0 1
    add a0 a0 t5
    add a1 a1 t6
    ble a2 t0 done
    j loop_start

done:
    add a0 t4 x0
    jr ra