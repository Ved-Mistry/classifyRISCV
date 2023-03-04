.globl classify

.text
# =====================================
# COMMAND LINE ARGUMENTS
# =====================================
# Args:
#   a0 (int)        argc
#   a1 (char**)     argv
#   a1[1] (char*)   pointer to the filepath string of m0
#   a1[2] (char*)   pointer to the filepath string of m1
#   a1[3] (char*)   pointer to the filepath string of input matrix
#   a1[4] (char*)   pointer to the filepath string of output file
#   a2 (int)        silent mode, if this is 1, you should not print
#                   anything. Otherwise, you should print the
#                   classification and a newline.
# Returns:
#   a0 (int)        Classification
# Exceptions:
#   - If there are an incorrect number of command line args,
#     this function terminates the program with exit code 31
#   - If malloc fails, this function terminates the program with exit code 26
#
# Usage:
#   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
classify:
    li t0 5
    bne a0 t0 err31
    
    addi sp sp -56
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
    sw a2 48(sp)
    sw ra 52(sp)
    
    lw s0 4(a1) #s0 is pointer to file with m0
    lw s1 8(a1) #s1 is pointer to file with m1
    lw s2 12(a1) #s2 is pointer to file with input
    lw s11 16(a1) #s11 is pointer to output filepath
    
    
    # Read pretrained m0
    li a0 4
    jal malloc
    beq a0 x0 err26
    mv s3 a0 #s3 is a pointer to an int rows m0
    
    li a0 4
    jal malloc
    beq a0 x0 err26
    mv s4 a0 #s4 is a pointer to an int cols m0
    
    mv a0 s0
    mv a1 s3
    mv a2 s4
    jal read_matrix
    mv s0 a0 #s0 is pointer to m0
    
    lw s10 0(s3)
    mv a0 s3
    jal free
    mv s3 s10 #s3 is int rows m0
    lw s10 0(s4)
    mv a0 s4
    jal free
    mv s4 s10 #s4 is int cols m0
    
    # Read pretrained m1
    li a0 4
    jal malloc
    beq a0 x0 err26
    mv s5 a0 #s5 is a pointer to an int rows m1
    
    li a0 4
    jal malloc
    beq a0 x0 err26
    mv s6 a0 #s6 is a pointer to an int cols m1
    
    mv a0 s1
    mv a1 s5
    mv a2 s6
    jal read_matrix
    mv s1 a0 #s1 is pointer to m1
    lw s10 0(s5)
    mv a0 s5
    jal free
    mv s5 s10 #s5 is int rows m1
    lw s10 0(s6)
    mv a0 s6
    jal free
    mv s6 s10 #s6 is int cols m1
    
    # Read input matrix
    li a0 4
    jal malloc
    beq a0 x0 err26
    mv s7 a0 #s7 is a pointer to an int rows input
    
    li a0 4
    jal malloc
    beq a0 x0 err26
    mv s8 a0 #s8 is a pointer to an int cols input
    
    mv a0 s2
    mv a1 s7
    mv a2 s8
    jal read_matrix
    mv s2 a0 #s2 is pointer to input
    lw s10 0(s7)
    mv a0 s7
    jal free
    mv s7 s10 #s7 is int rows input
    lw s10 0(s8)
    mv a0 s8
    jal free
    mv s8 s10 #s8 is int cols input
    
    # Allocate memory for new matrix m0 * input
    mul s10 s3 s8 #s10 is the number of elements in the array m0 * input
    li t0 4
    mul a0 t0 s10
    jal malloc
    beq a0 x0 err26
    mv s9 a0 #s9 is pointer to empty matrix for output of m0 * input

    # Compute h = matmul(m0, input)
    mv a0 s0
    mv a1 s3
    mv a2 s4
    mv a3 s2
    mv a4 s7
    mv a5 s8
    mv a6 s9
    
    jal matmul #s9 still points to the matrix, but now it is filled

#    mv t6 s9
#    mul t5 s3 s8
#    j printH

#printH:
#    lw a0 0(t6)
#    jal print_int
#    addi t6 t6 4
#    addi t5 t5 -1
#    beq t5 x0 cont4
#    li a0 ' '
#    jal print_char
#    j printH

#cont4:
    
#    li a0 '\n'
#    jal print_char


    # Compute h = relu(h)
    mv a0 s9
    mv a1 s10
    jal relu


    # Allocate memory for new matrix m1 * h
    mul s10 s5 s8 #s10 is the number of elements in the array m1 * h
    li t0 4
    mul a0 t0 s10
    jal malloc
    beq a0 x0 err26
    mv s7 a0 #s7 is pointer to empty matrix for output of m1 * h

    # Compute o = matmul(m1, h)
    mv a0 s1
    mv a1 s5
    mv a2 s6
    mv a3 s9
    mv a4 s3
    mv a5 s8
    mv a6 s7
    
    jal matmul #s7 still points to the matrix, but now it is filled
    
    # Write output matrix o
    #s6 = s3 !!! !!! !! !! !! !! ! ! ! ! ! !! ! 
    mv a0 s11
    mv a1 s7
    mv a2 s5
    mv a3 s8
    jal write_matrix


    # Compute and return argmax(o)
    mv a0 s7
    mv a1 s10
    jal argmax
    mv s6 a0 #s6 is the ARGMAX


    # If enabled, print argmax(o) and newline
    lw t0 48(sp)
    beq t0 x0 printer
    j done
    
err26:
    li a0 26
    j exit

err31:
    li a0 31
    j exit

printer:
    jal print_int
    li a0 '\n'
    jal print_char
    j done

done:
    mv a0 s7
    jal free
    mv a0 s9
    jal free
    #mv a0 s10
    #jal free
    #mv a0 s8
    #jal free
    #mv a0 s5
    #jal free
    #mv a0 s4
    #jal free
    #mv a0 s3 BAD
    #jal free BAD
    mv a0 s2
    jal free
    mv a0 s1
    jal free
    mv a0 s0
    jal free
   
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
    lw a2 48(sp)
    lw ra 52(sp)
    addi sp sp 56
    
    jr ra