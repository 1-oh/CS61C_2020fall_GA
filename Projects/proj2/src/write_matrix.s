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
# - If you receive an fopen error or eof,
#   this function terminates the program with error code 93.
# - If you receive an fwrite error or eof,
#   this function terminates the program with error code 94.
# - If you receive an fclose error or eof,
#   this function terminates the program with error code 95.
# ==============================================================================
write_matrix:

    # Prologue
    addi sp, sp, -36
    sw ra, 32(sp)
    sw s0, 0(sp)    # s0 is the pointer to string representing the filename
    sw s1, 4(sp)    # s1 is the pointer to the start of the matrix in memory
    sw s2, 8(sp)    # s2 is the number of rows in the matrix
    sw s3, 12(sp)   # s3 is the number of cols in the matrix
    sw s4, 16(sp)   # s4 is the file descriptor
    sw s5, 20(sp)   # s5 stores the pointer which points to the num of row
    sw s6, 24(sp)   # s6 stores the pointer which points to the num of col
    sw s7, 28(sp)   # s7 = s2 * s3

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    
    # malloc the memory for s5 and s6
    li a0, 4
    jal ra, malloc
    mv s5, a0

    li a0, 4
    jal ra, malloc
    mv s6, a0

    sw s2, 0(s5)
    sw s3, 0(s6)

    mul s7, s2, s3

    # Open the file
    mv a1, s0
    li a2, 1    # write mode
    jal ra, fopen
    li t0, -1
    beq a0, t0, fopen_error
    mv s4, a0

    # Write the num of rows and cols
    # - rows:
    mv a1, s4
    mv a2, s5
    li a3, 1
    li a4, 4
    jal ra, fwrite
    li t0, 1
    bne a0, t0, fwrite_error
    # - cols:
    mv a1, s4
    mv a2, s6
    li a3, 1
    li a4, 4
    jal ra, fwrite
    li t0, 1
    bne a0, t0, fwrite_error

    # Write the matrix
    mul t0, s2, s3  # num of element
    mv a1, s4
    mv a2, s1
    mv a3, t0
    li a4, 4
    jal ra, fwrite
    bne a0, s7, fwrite_error
    
    # Close the file
    mv a1, s4
    jal ra, fclose
    bnez a0, fclose_error
    
    # Free the memory
    mv a0, s5
    jal free
    mv a0, s6
    jal free

    # Epilogue
    lw ra, 32(sp)
    lw s0, 0(sp)
    lw s1, 4(sp)
    lw s2, 8(sp)
    lw s3, 12(sp)
    lw s4, 16(sp)
    lw s5, 20(sp)
    lw s6, 24(sp)
    lw s7, 28(sp)
    addi sp, sp, 36
    
    ret
fopen_error:
    li a1, 93
    jal ra, exit2
fwrite_error:
    li a1, 94
    jal ra, exit2
fclose_error:
    li a1, 95
    jal ra, exit2