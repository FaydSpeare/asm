.global _main
.align 4


// Implement string to integer conversion
atoi:
    mov W4, #0 // Initialize the result to 0

atoi_loop:
    ldrb W3, [X0], #1 // Load the first character, and increment the pointer
    cmp W3, #0 // Check for null terminator
    beq atoi_end
    sub W3, W3, #48 // Convert ASCII to integer
    mov W5, #10
    mul W4, W4, W5 // Multiply the result by 10
    add W4, W4, W3 // Add the new digit
    b atoi_loop

atoi_end:
    mov X0, X4 // Return the result
    ret 
    
_main:
    // X0 contains argc (the number of command line arguments)
    // X1 contains argv (a pointer to the first command line argument)

    // Each address is 8 bytes, argv[0] is the name of the program so
    // we skip the first 8 bytes to get argv[1]
    ldr X0, [X1, #8] // Load the address of the string
    bl atoi

    // The result of atoi is stored in X0 already, that will be our exit code
    mov X16, #1
    svc 0
