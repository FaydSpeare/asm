
.global _main
.align 4
   
// Take from: https://challenges.re/5/
//
// After analysing the assembly it appears to be a substring search function
// that returns a pointer to the substring if found and NULL if not found.
//
// Signature:
// char* f(char *s1, int len1, char *s2, int len2)
f:
        cmp     x3, x1
        bhi     .L9
        sub     x1, x1, x3
        mov     x8, 0
        adds    x9, x1, 1
        beq     .L9
.L12:
        cbz     x3, .L14
        mov     x1, 0
        mov     w4, 0
        add     x7, x0, x8
.L4:
        ldrb    w6, [x7, x1]
        ldrb    w5, [x2, x1]
        add     x1, x1, 1
        cmp     w6, w5
        csinc   w4, w4, wzr, eq
        cmp     x1, x3
        bne     .L4
        cbz     w4, .L6
        add     x8, x8, 1
        cmp     x8, x9
        bne     .L12
.L9:
        mov     x0, 0
        ret
.L14:
        add     x7, x0, x8
.L6:
        mov     x0, x7
        ret 

_main: 
    adr x0, message
    mov x1, #11
    adr x2, pattern
    mov x3, #2

    bl f
    mov x16, #1
    svc 0x80 

message: .asciz "Some string"
pattern: .asciz "me"
