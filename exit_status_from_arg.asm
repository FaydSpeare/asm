section .text
	global _start

_start:	
	mov rsi, [rsp + 16]
	call read_int
	mov rdi, rbx
	mov rax, 60
	syscall
