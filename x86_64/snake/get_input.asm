section .data
	buffer db 10

section .text
	global _start

_start:
	mov rax, 0
	mov rdi, 0
	mov rsi, buffer
	mov rdx, 10
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, 10
	syscall

	mov rdi, 0
	mov rax, 60
	syscall
