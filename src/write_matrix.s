.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
# Exceptions:
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fwrite error or eof,
#     this function terminates the program with error code 30
# ==============================================================================
write_matrix:

    addi sp sp -52
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
    sw ra 48(sp)

    mv s1 a1 #s1 is pointer to matrix
    mv s2 a2 #s2 is num rows
    mv s3 a3 #s3 is num cols
    li s7 4 #s3 is size of an int
    
    j opening
    
opening:
    li a1 1
    jal fopen
    li t0 -1
    beq a0 t0 err27
    j writerowcol
    
writerowcol:
    mv s4 a0 #s4 is the file descriptor
    
    mv a0 s7
    jal malloc
    mv s8 a0 #s8 is the pointer to rows
    sw s2 0(s8)
    
    mv a0 s7
    jal malloc
    mv s9 a0 #s9 is the pointer to cols
    sw s3 0(s9)
    
    mv a0 s4
    mv a1 s8
    li a2 1
    mv a3 s7
    
    jal fwrite
    li t0 1
    bne a0 t0 err30
    
    mv a0 s4
    mv a1 s9
    li a2 1
    mv a3 s7
    
    jal fwrite
    li t0 1
    bne a0 t0 err30

memory:
    mv a0 s4
    mv a1 s1
    mul a2 s2 s3
    mv a3 s7

    jal fwrite
    mul t0 s2 s3
    bne a0 t0 err30
    j closing

closing:
    mv a0 s4
    jal fclose
    bne a0 x0 err28
    j done

err27:
    li a0 27
    j exit

err28:
    li a0 28
    j exit

err30:
    li a0 30
    j exit
    
done:
    mv a0 s9
    jal free
    mv a0 s8
    jal free

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
    lw ra 48(sp)
    addi sp sp 52

    jr ra
