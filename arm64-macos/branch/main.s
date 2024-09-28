.global _main
.align 4

// Function argument are passed in registers X0-X7
// Return value is passed back via X0 (and X1 for 128-bit values)
add_nums:
    add X0, X0, X1
    ret // Return to the address in the link register (LR)

_main:

    // Call add_nums(5, 6)
    mov X0, #5
    mov X1, #6
    adr LR, .+8 // Specify the address to return after calling the subroutine
    b add_nums // Branch to the subroutine

    // Alternatively, we can use the bl instruction to call a subroutine
    // and automatically set the link register to the next instruction
    // Call add_nums(10, 20)
    mov X0, #10
    mov X1, #20
    bl add_nums

    mov X16, #1 // exit syscall
    svc 0 // call the kernel
