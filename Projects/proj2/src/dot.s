.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 75.
# - If the stride of either vector is less than 1,
#   this function terminates the program with error code 76.
# =======================================================
dot:

    # Prologue
    addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)

    mv s0, a0
    mv s1, a1
    mv s2, a2
    mv s3, a3
    mv s4, a4

    blez s2, error_exit1 
    blez s3, error_exit2
    blez s4, error_exit2

    li t0, 0     # t0 is the index that we traverse
    li a0, 0     # initialize a0 (the sum) to be 0
loop_start:
    bge t0, s2, loop_end
    mul t1, t0, s3  
    mul t2, t0, s4  
    slli t1, t1, 2  # t1 is the address offset of vector1
    slli t2, t2, 2  # t2 is the address offset of vector2
    
    add t3, s0, t1  # t3 is the pointer to the element in vector1
    add t4, s1, t2  # t4 is the pointer to the element in vector2
    
    lw t5, 0(t3)
    lw t6, 0(t4)
    
    # t1 now means the product of t5 and t6
    mul t1, t5, t6
    add a0, a0, t1
    addi t0, t0, 1
    j loop_start

loop_end:

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    addi sp, sp, 24

    ret

error_exit1:
    li a1, 75
    jal ra, exit2
error_exit2:
    li a1, 76
    jal ra, exit2