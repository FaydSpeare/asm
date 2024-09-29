
.global _main
.align 4
   
_main:
    mov w1, #10
    sub w2, w1, #65
    uxtb w2, w2
    mov x0, #0
    mov x16, #1
    svc 0x80 
