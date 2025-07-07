.globl factorial

.data
n: .word 8

.text
main:
    la t0, n
    lw a0, 0(t0)
    jal ra, factorial

    addi a1, a0, 0
    addi a0, x0, 1
    ecall # Print Result

    addi a1, x0, '\n'
    addi a0, x0, 11
    ecall # Print newline

    addi a0, x0, 10
    ecall # Exit

factorial:
    addi sp, sp, -12
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)

    add s0, a0, x0      # s0 = n
    beq s0, x0, base_case

    addi a0, s0, -1     # a0 = n - 1
    jal ra, factorial   # recursive call
    add s1, a0, x0      # s1 = factorial(n - 1)
    mul a0, s0, s1      # a0 = n * factorial(n - 1)
    j end_factorial

base_case:
    li a0, 1            # factorial(0) = 1

end_factorial:
    lw ra, 0(sp)
    lw s0, 4(sp)
    lw s1, 8(sp)
    addi sp, sp, 12
    jr ra