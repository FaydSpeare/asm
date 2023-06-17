global string_to_int
global int_to_string

; Tries to read an integer from %rsi
; Uses %rax and %rbx
; Returns the result in %rbx
string_to_int:
	push rbp
	mov rbp, rsp
	xor rax, rax    ; clear rax
	xor rbx, rbx    ; clear rbx

read_int_loop:
	mov al, byte [rsi]          ; load byte (char) from rsi into al
	inc rsi
	cmp al, 0
	je read_int_end
	sub al, '0'
	imul rbx, 10
	add rbx, rax
	jmp read_int_loop
	
read_int_end:
	pop rbp
	ret


; Integer given in %rax
; Buffer to write string to in %rbx
int_to_string:
	push rbp
	mov rbp, rsp
	mov r8, 0
	
push_ints_loop:
	inc r8         ; count the number of digits
	xor rdx, rdx   ; clear %rdx to store remainder
	mov rcx, 10
	div rcx
	add dl, '0'
	push rdx
	cmp rax, 0
	jne push_ints_loop
	
	mov rcx, 0     ; pop and append %r8 nums
pop_ints_loop:
	pop rdx	
	mov byte [rbx + rcx], dl
	inc rcx
	cmp r8, rcx
	jne pop_ints_loop

int_to_string_end:	
	pop rbp
	ret
