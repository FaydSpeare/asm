section .data
	buffer db 50 DUP (0)
	buffer_len equ $ - buffer

section .text
	global _start

_start:	
	mov edi, buffer
	mov al, 70
	mov ah, 10
	mov rcx, 25
	rep stosw

	mov rdi, buffer+16
	mov rax, ' h ... w'
	mov al, 10
	ror rax, 8
	mov rcx, 3
	rep stosq

	mov rdi, buffer
	mov eax, " MMM"
	mov al, 10,
	ror eax, 8
	mov rcx, 4
	rep stosd

	mov rax, 1
	mov rdi, 1
	mov rsi, buffer
	mov rdx, buffer_len
	syscall
	
	mov rdi, 0
	mov rax, 60
	syscall
