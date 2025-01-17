.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
#   d = matmul(m0, m1)
# Arguments:
#   a0 (int*)  is the pointer to the start of m0
#   a1 (int)   is the # of rows (height) of m0
#   a2 (int)   is the # of columns (width) of m0
#   a3 (int*)  is the pointer to the start of m1
#   a4 (int)   is the # of rows (height) of m1
#   a5 (int)   is the # of columns (width) of m1
#   a6 (int*)  is the pointer to the the start of d
# Returns:
#   None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 38
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 38
# =======================================================
matmul:
    ble a1 x0 err
    ble a2 x0 err 
    ble a4 x0 err
    ble a5 x0 err
    bne a2 a4 err
    
    addi sp sp -48
    sw s0 0(sp)
    sw s1 4(sp)
    sw s2 8(sp)
    sw s3 12(sp)
    sw s4 16(sp)
    sw s5 20(sp)
    sw s6 24(sp)
    sw s7 28(sp)
    sw s8 32(sp)
    sw s9 36(sp)
    sw s10 40(sp)
    sw s11 44(sp)
    
    mv s0 a0 #first matrix
    mv s1 a1 #num rows
    add s2 x0 x0 #row mover
    mv s3 a3 #second matrix
    add s4 x0 x0 #rows covered
    add s5 x0 x0 #columns covered
    addi s6 x0 4 #size of int
    mv s7 a6
    mv s8 a2
    mv s9 a5
    mv s10 a6
    mv s11 ra
    
    mv a1 a3 #
    addi a3 x0 1
    mv a4 a5 #num cols
    j inner_loop_start

err:
    li a0 38
    j exit

inner_loop_start:
    jal ra dot
    mv a6 s10
    sw a0 0(a6)
    addi s10 s10 4
    
    mv a0 s0
    mv a2 s8
    addi a3 x0 1
    mv a4 s9
    
    add a0 s0 s2
    addi s5 s5 1 #add to total cols covered
    mul s5 s5 s6 #multiply cols covered by size of int
    add a1 s3 s5 #reset a1 to beginning of a col in the array
    div s5 s5 s6 # divide cols covered by size of int to recover og val
    bge s5 a4 outer_loop_end #check if all cols have been covered
    blt s5 a4 inner_loop_start

outer_loop_end:
    addi s4 s4 1 #add to total rows covered
    mul s2 s4 a2 #move the row adder down a row
    mul s2 s2 s6 #multiply row adder by size of int
    add a0 s0 s2 #reset a0 to beginning of a row in the array
    mv a1 s3 #reset second matrix
    add s5 x0 x0 #reset col adjustment
    blt s4 s1 inner_loop_start #next row dot product
    bge s4 s1 done #check if all rows have been covered

done:
    lw a6 0(s7)
    mv ra s11
    lw s0 0(sp)
    lw s1 4(sp)
    lw s2 8(sp)
    lw s3 12(sp)
    lw s4 16(sp)
    lw s5 20(sp)
    lw s6 24(sp)
    lw s7 28(sp)
    lw s8 32(sp)
    lw s9 36(sp)
    lw s10 40(sp)
    lw s11 44(sp)
    addi sp sp 48
    jr ra
