.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # Exceptions:
    # - If there are an incorrect number of command line args,
    #   this function terminates the program with exit code 89.
    # - If malloc fails, this function terminats the program with exit code 88.
    #
    # Usage:
    #   main.s <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    li t0, 5
    bne a0, t0, args_num_error

    addi sp, sp, -52
    sw ra, 0(sp)    
    sw s0, 4(sp)    # s0: pointer to the input matrix
    sw s1, 8(sp)    # s1 is argv
    sw s2, 12(sp)   # s2: print_classification signal
    sw s3, 16(sp)   # s3: pointer to the matrix m0
    sw s4, 20(sp)   # s4: pointer to the matrix m1
    sw s5, 24(sp)   # s5: pointer to the num of rows in m0  
    sw s6, 28(sp)   # s6: pointer to the num of cols in m0
    sw s7, 32(sp)   # s7: pointer to the num of rows in m1
    sw s8, 36(sp)   # s8: pointer to the num of cols in m1
    sw s9, 40(sp)   # s9: pointer to the num of rows in input
    sw s10, 44(sp)  # s10: pointer to the num of cols in output
    sw s11, 48(sp)  # s11: media variable

    mv s1, a1
    mv s2, a2

    # malloc memory for s5, s6, s7, s8, s9, s10
    li a0, 4
    jal ra, malloc
    li t0, -1
    beq a0, t0, malloc_error
    mv s5, a0

    li a0, 4
    jal ra, malloc
    li t0, -1
    beq a0, t0, malloc_error
    mv s6, a0

    li a0, 4
    jal ra, malloc
    li t0, -1
    beq a0, t0, malloc_error
    mv s7, a0

    li a0, 4
    jal ra, malloc
    li t0, -1
    beq a0, t0, malloc_error
    mv s8, a0

    li a0, 4
    jal ra, malloc
    li t0, -1
    beq a0, t0, malloc_error
    mv s9, a0

    li a0, 4
    jal ra, malloc
    li t0, -1
    beq a0, t0, malloc_error
    mv s10, a0
	# =====================================
    # LOAD MATRICES
    # =====================================
    
    # Load pretrained m0
    lw t0, 4(s1)    # m0_path
    mv a0, t0
    mv a1, s5
    mv a2, s6
    jal ra, read_matrix
    mv s3, a0
    
    # Load pretrained m1
    lw t0, 8(s1)    # m1_path
    mv a0, t0
    mv a1, s7
    mv a2, s8
    jal ra, read_matrix
    mv s4, a0

    # Load input matrix
    lw t0, 12(s1)    # input_path
    mv a0, t0
    mv a1, s9
    mv a2, s10
    jal ra, read_matrix
    mv s0, a0

    # =====================================
    # RUN LAYERS
    # =====================================
    # s11 is the media variable

    # 1. LINEAR LAYER:    m0 * input
    lw a1, 0(s5)    # num of rows in m0
    lw a5, 0(s10)   # num of cols in input
    
    # malloc for the result
    mul t0, a1, a5
    slli t0, t0, 2  # t0 is the size of the memory that we need to malloc for s11
    mv a0, t0
    jal ra, malloc
    mv s11, a0

    mv a0, s3
    lw a1, 0(s5)    # num of rows in m0
    lw a2, 0(s6)    # num of cols in m0
    mv a3, s0 
    lw a4, 0(s9)    # num of rows in input
    lw a5, 0(s10)   # num of cols in input
    mv a6, s11
    jal ra, matmul
    
    # Free m0 and input
    mv a0, s3
    jal ra, free
    mv a0, s0
    jal ra, free

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    lw a1, 0(s5)    # num of rows in m0
    lw a5, 0(s10)   # num of cols in input
    # t0 is the number of matrix 's element
    mul t0, a1, a5
    mv a0, s11
    mv a1, t0
    jal ra, relu

    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input)
    lw a1, 0(s7)    # num of rows in m1
    lw a5, 0(s10)   # num of cols in input(also the t1)
    # malloc for the result
    mul t0, a1, a5
    slli t0, t0, 2  # t0 is the size of the memory that we need to malloc for s11
    mv a0, t0
    jal ra, malloc

    mv t1, s11      # t1 is the address of the matrix after relu 
    mv s11, a0

    mv a0, s4
    lw a1, 0(s7)    # num of rows in m1
    lw a2, 0(s8)    # num of cols in m1
    mv a3, t1
    mv s3, t1       # use s3 to save t1 
    lw a4, 0(s5)    # num of rows in t1
    lw a5, 0(s10)   # num of cols in t1
    mv a6, s11
    jal ra, matmul
    
    # Free m1 and t1
    mv a0, s4
    jal ra, free
    mv a0, s3
    jal ra, free

    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    lw t0, 16(s1)   # the output path
    mv a0, t0
    mv a1, s11
    lw a2, 0(s7)
    lw a3, 0(s10)
    jal ra, write_matrix
    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    lw t1, 0(s7)  
    lw t2, 0(s10)  
    mul t0, t1, t2 # the num of element
    mv a0, s11
    mv a1, t0
    jal ra, argmax
    mv s3, a0       # s3 now is the num of classification

    # free the matrix s11
    mv a0, s11
    jal ra, free

    # Print classification
    bne s2, x0, not_print_anything
    mv a1, s3
    jal ra, print_int

    # # Print newline afterwards for clarity
    li t0, '\n'
    mv a1, t0
    jal ra, print_char

    not_print_anything:
    mv a0, s5
    jal free
    mv a0, s6
    jal free
    mv a0, s7
    jal free
    mv a0, s8
    jal free
    mv a0, s9
    jal free
    mv a0, s10
    jal free
    mv a0, s11
    jal free
    
    mv a0, s3

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
    lw s9, 40(sp)
    lw s10, 44(sp)
    lw s11, 48(sp)
    addi sp, sp, 52

    ret

args_num_error:
    li a1, 89
    jal ra, exit2
malloc_error:
    li a1, 88
    jal ra, exit2