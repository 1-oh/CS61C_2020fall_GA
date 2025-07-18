.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
# Exceptions:
# - If the length of the vector is less than 1,
#   this function terminates the program with error code 78.
# ==============================================================================
relu:
    # Prologue
    # To check if the length of array is legal or not
    li t0, 1
    blt a1, t0, error_exit

    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)     # s0 stores the address of the array
    sw s1, 8(sp)     # s1 stores the number of element
    
    mv s0, a0
    mv s1, a1
    add t0, x0, x0   # t0 is the index of the element
loop_start:
    bge t0, s1, loop_end
    blt t0, s1, loop_continue

loop_continue:
    slli t1, t0, 2  # t1 = 4 * t0, which is the address offset between the element and the first one
    add t2, s0, t1 # t2 is the pointer to the element
    lw t3, 0(t2)
    bge t3, x0, positive
    sw x0 , 0(t2)
    
positive:
    addi t0, t0, 1
    j loop_start

loop_end:
    # Epilogue
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
	ret

error_exit:
   li a7, 93     # syscall number for exit
   li a0, 78     # exit code
   ecall

