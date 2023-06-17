extern string_to_int
extern int_to_string

section .data
	buffer db 30 DUP (0)
	buffer_len equ 30

section .text
	global _start

_start:	
	mov rcx, [rsp]   ; number of args
	sub rcx, 1
	mov rdx, 0       ; sum of the args
	cmp rcx, 0
	je print_sum
	mov r8, 8
sum:	
	add r8, 8
	mov rsi, [rsp + r8]
	call string_to_int
	add rdx, rbx
	dec rcx
	cmp rcx, 0
	jne sum

print_sum:	
	mov rax, rdx
	mov rbx, buffer
	call int_to_string
	
	mov rax, 1
	mov rdi, 1	
	mov rsi, buffer
	mov rdx, buffer_len
	syscall
	
	mov rdi, 0
	mov rax, 60
	syscall
