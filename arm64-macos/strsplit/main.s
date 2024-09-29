
.global _main
.align 4
   
// Code modified from https://challenges.re/6/
// Function appears to create a copy of the string in x0 to x1
// while inserting a null byte after each character.
f:
    ldrb w2, [x0]
    strh w2, [x1]
    cbz w2, f_end
f_iter:
    ldrb w2, [x0,#1]!
    strh w2, [x1,#2]!
    cbnz w2, f_iter
f_end:
    ret

_main:
    // Allocate stack space for x1
    sub sp, sp, #16

    mov x1, sp
    adr x0, message
    bl f

    // Deallocate stack space
    add sp, sp, #16
 
    mov x0, #0
    mov x16, #1
    svc 0x80 

message: .asciz "some\n"
