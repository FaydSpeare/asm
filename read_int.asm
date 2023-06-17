global read_int

; Tries to read an integer from %rsi
; Uses %rax and %rbx
; Returns the result in %rax
read_int:
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
