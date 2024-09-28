
.global _main
.align 4

// Stack has to be 16-byte aligned on arm64
_main:
    mov x0, #14
    mov x1, #15
    sub sp, sp, #16 // Create some space on the stack

    str x0, [sp] // Push x0 onto the stack
    str x1, [sp, #8] // Push x1 onto the stack

    // Do something...

    ldr x0, [sp] // Pop x0 from the stack
    ldr x1, [sp, #8] // Pop x1 from the stack

    add sp, sp, #16 // Remove the space from the stack

    mov x0, x1
    mov x16, #1
    svc 0x80 
