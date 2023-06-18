section .data
	buffer db "X_______"
	buffer_len equ $ - buffer
	clear db 27, "[H", 27, "[2J"
	clear_len equ $ - clear
	timespec_struct:
		tv_sec  dq 0  ; Seconds
		tv_nsec dq 100000000  ; Nanoseconds

section .text
	global _start

_start:	
	mov r8, 50000

loop: 
	dec r8
	rol qword [buffer], 8

	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, buffer_len
	syscall

	mov rax, 35
	mov rdi, timespec_struct
	syscall
	
	mov rax, 1
	mov rdi, 1
	mov rsi, clear
	mov rdx, clear_len
	syscall
	
	cmp r8, 0
	jne loop

end:	
	mov rdi, 0
	mov rax, 60
	syscall
