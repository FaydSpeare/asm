section .data
    buffer db 1
    pollfd:
	fd dd 0
	events dw 0
	revents dw 0

section .text
    global _start

_start:
    mov dword [pollfd], 0
    mov word [pollfd + 4], 1

poll_loop:
    mov word [pollfd + 6], 0

    mov rax, 7
    mov rsi, 1
    mov rdi, pollfd
    mov rdx, 0
    syscall

    cmp word [pollfd+6], 1
    jne poll_loop

    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    mov rdx, 1
    syscall
    jmp poll_loop

exit_program:
    mov rax, 60                 
    xor rdi, rdi                
    syscall
