section .text
    global _start

_start:
    mov rdx, [rsp]
    mov rbx, 8
    mov rcx, 0
sum:
    dec rdx
    add rbx, 8
    mov rdi, [rsp + rbx] 
    movzx rax, byte [rdi]
    sub al, '0'
    add rcx, rax
    cmp rdx, 1
    jne sum 
 
    mov rdi, rcx
    mov rax, 60
    syscall

; _start:
;     mov rbx, [rsp]
;     mov rsi, [rsp + 16]
; 
;     mov rdx, 0
;     mov al, byte [rsi]
;     cmp al, 0
;     je print_arg
; 
; count_len:
;     inc rdx
;     inc rsi
;     mov al, byte [rsi]
;     cmp al, 0
;     jne count_len
; 
; print_arg:
;     mov rax, 1
;     mov rdi, 1
;     mov rsi, [rsp + 16]
;     syscall   
;     mov rbx, rdx 
; 
;     call func
;     syscall
; 
; 
; func:
;     mov rax, 60
;     mov rdi, rbx
;     ret
