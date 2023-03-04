.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
# Exceptions:
#   - If malloc returns an error,
#     this function terminates the program with error code 26
#   - If you receive an fopen error or eof,
#     this function terminates the program with error code 27
#   - If you receive an fclose error or eof,
#     this function terminates the program with error code 28
#   - If you receive an fread error or eof,
#     this function terminates the program with error code 29
# ==============================================================================
read_matrix:

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

    mv s1 a1 #s1 is pointer to rows
    mv s2 a2 #s2 is pointer to cols
    li s3 4 #s3 is size of an int
    
    j opening
    
opening:
    li a1 0
    jal fopen
    li t0 -1
    beq a0 t0 err27
    j readrowcol
    
readrowcol:
    mv s4 a0 #s4 is the file descriptor
    mv a1 s1
    mv a2 s3
    
    jal fread
    bne a0 s3 err29
    
    mv a0 s4
    mv a1 s2
    mv a2 s3
    
    jal fread
    bne a0 s3 err29

memory:
    lw t1 0(s1)
    lw t2 0(s2)
    mul s5 t1 t2
    mul s5 s5 s3

    mv a0 s5 #s5 is num bytes
    jal malloc
    li t0 0
    beq a0 t0 err26
    
    mv s6 a0 #s6 is the pointer to memory
    j readmat
    
readmat:
    mv a0 s4
    mv a1 s6
    mv a2 s5
    jal fread
    bne a0 s5 err29
    j closing

closing:
    mv a0 s4
    jal fclose
    bne a0 x0 err28
    j done
    
err26:
    li a0 26
    j exit

err27:
    li a0 27
    j exit

err28:
    li a0 28
    j exit

err29:
    li a0 29
    j exit
    
done:
    mv a0 s6
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