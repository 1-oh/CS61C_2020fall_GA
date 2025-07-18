### Answer to Action Item Questions
#### EX1
1. What do the ```.data```, ```.word```, ```.text``` directives mean (i.e. what do you use them for)? Hint: think about the 4 sections of memory.
   + **The ```.data``` defines the static section of the memory, where initialized global/static variables are stored.**
   + **The ```.word``` allocates space for 32-bit(4 byte) integers in the ```.data``` section(or other sections if explicitly placed)**
   + **The ```.text``` defines the code section**
2. Run the program to completion. What number did the program output? What does this number represent?
   + **output:34**
   + **represent: Fib(9)=34**
3. At what address is ```n``` stored in memory? Hint: Look at the contents of the registers.
   **0x10000010**
4. Without actually editing the code (i.e. without going into the “Editor” tab), have the program calculate the 13th fib number (0-indexed) by manually modifying the value of a register. You may find it helpful to first step through the code. If you prefer to look at decimal values, change the “Display Settings” option at the bottom.
   **233**
#### EX2
Find/explain the following components of this assembly file.
+ The register representing the variable k.
  **t0**
+ The register representing the variable sum.
  **s0**
+ The registers acting as pointers to the source   and dest arrays.
  **source:s1
  dest:s2***
+ The assembly code for the loop found in the C code.
  ```
  loop:
    slli s3, t0, 2
    add t1, s1, s3
    lw t2, 0(t1)
    beq t2, x0, exit
    add a0, x0, t2
    addi sp, sp, -8
    sw t0, 0(sp)
    sw t2, 4(sp)
    jal fun
    lw t0, 0(sp)
    lw t2, 4(sp)
    addi sp, sp, 8
    add t2, x0, a0
    add t3, s2, s3
    sw t2, 0(t3)
    add s0, s0, t2
    addi t0, t0, 1
    jal x0, loop
   exit:
  ```
+ How the pointers are manipulated in the assembly code.
  **```t0```is the offset.```t1``` is the pointer to the element in  source array, ```t1 = s1 + 4 * t0```.```t3``` is the pointer to the element in dest array,```t3 = s2 + 4 * t0```.**