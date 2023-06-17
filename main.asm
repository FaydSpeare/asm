extern string_to_int
extern int_to_string

section .data
	phrase db "sys_gettimeofday_secs: ", 0
	phrase_len equ $ - phrase
	buffer db 20 DUP (0)
	buffer_len equ 20
	timeval_struct:
		timeval_sec dq 0  ; seconds
		timeval_usec dq 0 ; microseconds

section .text
	global _start

_start:	
	mov rdi, timeval_struct
	mov rax, 96
	syscall

	mov rax, qword [timeval_struct]
	mov rbx, buffer
	call int_to_string
	
	mov byte [buffer + buffer_len - 1], 10	

	mov rax, 1
	mov rdi, 1
	mov rsi, phrase
	mov rdx, phrase_len
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, buffer_len
	syscall
	
	mov rdi, 0
	mov rax, 60
	syscall
