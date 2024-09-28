.global _main
.align 4

_main:
    mov X0, #1 // STDOUT file descriptor
    adr X1, msg // address of the string
    mov X2, #7 // length of the string
    mov X16, #4 // write syscall
    svc 0 // call the kernel

    mov X0, #0 // exit code
    mov X16, #1 // exit syscall
    svc 0 // call the kernel
 
msg: .ascii "Write!\n"
