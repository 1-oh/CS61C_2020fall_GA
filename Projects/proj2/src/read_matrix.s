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
# - If malloc returns an error,
#   this function terminates the program with error code 88.
# - If you receive an fopen error or eof, 
#   this function terminates the program with error code 90.
# - If you receive an fread error or eof,
#   this function terminates the program with error code 91.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 92.
# ==============================================================================
read_matrix:

    # Prologue
	addi sp, sp, -28
    sw ra, 0(sp)     
    sw s0, 4(sp)     # filename
    sw s1, 8(sp)     # pointer to num of rows
    sw s2, 12(sp)    # pointer to num of cols
    sw s3, 16(sp)    # s3 is the file desciptor
    sw s4, 20(sp)    # s4 is the pointer to the matrix
    sw s5, 24(sp)    # s5 is the size of memory we need to malloc

    mv s0, a0
    mv s1, a1
    mv s2, a2

    # Open the file
    mv a1, s0   # file name
    li a2, 0    # read mode
    jal ra, fopen

    li t0, -1
    beq a0, t0, open_error
    mv s3, a0

    # Read the nums of rows and cols
    # - num of rows
    mv a1, s3   # file descriptor
    mv a2, s1
    li a3, 4
    jal ra, fread
    li t0, 4
    bne a0, t0, read_error
    # - num of cols
    mv a1, s3   # file descriptor
    mv a2, s2
    li a3, 4
    jal ra, fread
    li t0, 4
    bne a0, t0, read_error

    # malloc the memory
    lw t0, 0(s1)
    lw t1, 0(s2)
    mul t2, t0, t1
    slli t2, t2, 2  # t2 is the size that we need to malloc
    mv s5, t2
    mv a0, t2
    jal ra, malloc
    li t0, 0
    beq a0, t0, malloc_error
    mv s4, a0
    
    # read the matrix
    mv a1, s3
    mv a2, s4
    mv a3, s5   # t2 is the size that we need to read
    jal ra, fread
    bne s5, a0, read_error
    
    # close the file
    mv a1, s3   # file descriptor
    jal ra, fclose
    bnez a0, close_error
    
    mv a0, s4

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    ret

malloc_error:
    li a1, 88
    jal ra exit2
open_error:
    li a1, 90
    jal ra exit2
close_error:
    li a1, 92
    jal ra, exit2
read_error:
    mv a1, s3
    jal fclose 
    li a1, 91
    jal ra, exit2