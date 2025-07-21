.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# Exceptions:
#   Make sure to check in top to bottom order!
#   - If the dimensions of m0 do not make sense,
#     this function terminates the program with exit code 72.
#   - If the dimensions of m1 do not make sense,
#     this function terminates the program with exit code 73.
#   - If the dimensions of m0 and m1 don't match,
#     this function terminates the program with exit code 74.
# =======================================================
matmul:

    # Error checks
    blez a1, error_exit1
    blez a2, error_exit1
    blez a4, error_exit2
    blez a5, error_exit2
    bne a2, a4, error_exit3
    # Prologue
    addi sp, sp, -40
    sw ra, 0(sp)      
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)

    mv s0, a0            #  s0 (int*)  is the pointer to the start of m0 
    mv s1, a1            #	s1 (int)   is the # of rows (height) of m0(also d)
    mv s2, a2            #	s2 (int)   is the # of columns (width) of m0
    mv s3, a3            #	s3 (int*)  is the pointer to the start of m1
    mv s4, a4            # 	s4 (int)   is the # of rows (height) of m1
    mv s5, a5            #	s5 (int)   is the # of columns (width) of m1(also d)
    mv s6, a6            #	s6 (int*)  is the pointer to the the start of d

    li s7, 0             #  s7 is the coodinate of row in d
    li s8, 0             #  s8 is the coodinate of column in d     

outer_loop_start:
    li s8, 0
    bge s7, s1, outer_loop_end     

inner_loop_start:
    bge s8, s5, inner_loop_end
    
    mul t2, s7, s2
    slli t2, t2, 2
    add t2, t2, s0

    li t4, 4
    mul t3, s8, t4
    add t3, t3, s3

    mv a0, t2            # a0 (int*) is the pointer to the start of v0
    mv a1, t3            # a1 (int*) is the pointer to the start of v1
    mv a2, s2            # a2 (int)  is the length of the vectors
    li a3, 1             # a3 (int)  is the stride of v0
    mv a4, s5            # a4 (int)  is the stride of v1
    jal ra, dot

    mul t2, s7, s5       # t2 =  s7 * s5
    add t3, t2, s8       # t3 is the index of 1-D array transistioned from the 2-D dimension  
    slli t3, t3, 2       # t3 = t3 * 4
    add t3, t3, s6       # t3 is the address that we want to save data
    sw a0, 0(t3)

    addi s8, s8, 1
    j inner_loop_start

inner_loop_end:
    addi  s7,  s7, 1
    j outer_loop_start



outer_loop_end:
    # Epilogue
    lw ra, 0(sp)      
    lw s0, 4(sp)
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    lw s6, 28(sp)
    lw s7, 32(sp)
    lw s8, 36(sp)
    addi sp, sp, 40
    ret

error_exit1:
    li a1, 72
    jal ra, exit2
error_exit2:
    li a1, 73
    jal ra, exit2
error_exit3:
    li a1, 74
    jal ra, exit2