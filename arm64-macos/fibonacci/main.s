
.global _main
.align 4


# fibonacci(int n)
# Returns the nth fibonacci number
fibonacci:
    
    // Push the frame pointer and link register onto the stack
    stp fp, lr, [sp, #-16]!

    // Set up the frame pointer for this function
    mov fp, sp

    // Base cases:
    // fib(0) = 0
    // fib(1) = 1 
    //
    // To handle the base cases, we simply branch to the end of the function
    // if n <= 1 as n is already in x0 and that will be the return value too.
    cmp x0, #1
    ble fib_end
    
fib_n:
    // Allocate some space on the stack for:
    // - The value of n
    // - The result of fib(n-1)
    sub sp, sp, #16
    str x0, [fp, #-8]

    sub x0, x0, #1
    bl fibonacci // x0 = fib(n-1)
    str x0, [fp, #-16] // Store fib(n-1) on the stack 

    ldr x0, [fp, #-8] 
    sub x0, x0, #2
    bl fibonacci // x0 = fib(n-2)

    ldr x2, [fp, #-16] // Load fib(n-1) from the stack
    add x0, x2, x0 // x0 = fib(n-1) + fib(n-2)
    b fib_end

fib_end:
    mov sp, fp // Restore the stack pointer
    ldp fp, lr, [sp], #16 // Restore frame
    ret


_main:
    // Call fibonacci(8)
    mov x0, #8
    bl fibonacci
    
    // Result is in x0, for the exit code
    mov x16, #1
    svc 0x80 
