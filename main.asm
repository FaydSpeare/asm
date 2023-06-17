extern read_int

section .data
	buffer db "HEY"

section .text
	global _start

_start:	
	mov rsi, [rsp + 16]
	call read_int
	
	mov rax, 1
	mov rdi, 1	
	mov rsi, buffer
	mov rdx, 3
	syscall
	
	mov rdi, 0
	mov rax, 60
	syscall
