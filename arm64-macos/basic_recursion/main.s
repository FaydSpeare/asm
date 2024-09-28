
.global _main
.align 4

// Subroutine to print a message x0 number of times using recursion.
recursive_print:
    // Push the link register to the stack
    sub sp, sp, #16
    str lr, [sp]

    mov x5, x0 // Save x0 into x5

    // Print a message
    mov x0, #1
    adr x1, message
    mov x2, #6
    mov X16, #4
    svc 0x80

    mov x0, x5 // Restore x0 from x5

    cmp x0, #0
    bne recurse

    // Pop the link register from the stack
    ldr lr, [sp]
    add sp, sp, #16
    ret

recurse:
    sub x0, x0, #1
    bl recursive_print

    // Pop the link register from the stack
    ldr lr, [sp]
    add sp, sp, #16
    ret


// Stack has to be 16-byte aligned on arm64
_main:
    mov x0, #10
    bl recursive_print
    
    mov x0, #0
    mov x16, #1
    svc 0x80 

message: .asciz "Hello\n"
