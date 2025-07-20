.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 77.
# =================================================================
argmax:

    # Prologue
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    mv s0, a0    # s0 is the address of the array
    mv s1, a1    # s1 is the number of elements of the array
    
    # If the s1 <= 0, then we branch to error_exit
    blez s1, error_exit

    # t0 is the index that we traverse
    li t0, 0
    # t1 is the index of the max element
    li t1, 0
    # t2 is the value of the max element
    lw t2, 0(s0)
loop_start:
    bge t0, s1, loop_end

loop_continue:
    # t3 is the address offset
    slli t3, t0, 2
    # t4 is the address of the current element
    add t4, s0, t3
    # t5 is the value of the current element
    lw t5, 0(t4)

    ble t5, t2, skip_upgrade
    # if the current element is larger, then we upgrade
    mv t1, t0
    mv t2, t5
    skip_upgrade:
    addi t0, t0, 1
loop_end:
    mv a0, t1

    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    ret

error_exit:
    li a0, 77
    li a7, 93   # linux exit syscall
    ecall
