section .data
    county dd 0
    count dd 0
    newline db 10
    space db " " 
    x db "H"
    clear db 27, "[H", 27, "[2J"
    clear_len equ $ - clear
    buffer db 1
    pollfd:
	fd dd 0
	events dw 0
	revents dw 0
    termios:
	c_iflag dd 1
	c_oflag dd 1
	c_cflag dd 1
	c_lflag dd 1
	c_line  db 1
	c_cc    db 19 

section .text
    global _start

_start:
    mov dword [pollfd], 0
    mov word [pollfd + 4], 1

    sub rsp, 18
 
    ; Get current settings
    mov  eax, 16             ; syscall number: SYS_ioctl
    mov  edi, 0              ; fd:      STDIN_FILENO
    mov  esi, 0x5401         ; request: TCGETS
    mov  rdx, rsp        ; request data
    syscall

    ; Modify flags
    and byte [rsp+12], 0FDh  ; Clear ICANON to disable canonical mode
    
    ; Write termios structure back
    mov  eax, 16             ; syscall number: SYS_ioctl
    mov  edi, 0              ; fd:      STDIN_FILENO
    mov  esi, 0x5402         ; request: TCSETS
    mov  rdx, rsp        ; request data
    syscall
    
    add rsp, 18

    mov rbx, 0
    mov rcx, 0
    
poll_loop:
    call clear_term 
    call print_pos
    mov word [pollfd + 6], 0
    
    mov rax, 7
    mov rsi, 1
    mov rdi, pollfd
    mov rdx, 100
    syscall
    
    cmp word [pollfd+6], 1
    jne poll_loop
    
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 1
    syscall
     
    cmp byte [buffer], 106
    je _j

    cmp byte [buffer], 107
    je _k

    cmp byte [buffer], 104
    je _h

    cmp byte [buffer], 108
    je _l

    jmp poll_loop

_k:
    mov r8d, dword [count]
    sub r8, 1
    mov edx, 0
    cmovs r8d, edx
    mov dword [count], r8d
    jmp poll_loop

_j:
    mov r8d, dword [count]
    add r8, 1
    mov dword [count], r8d  
    jmp poll_loop

_h:
    mov r9d, dword [county]
    sub r9, 1
    mov edx, 0
    cmovs r9d, edx
    mov dword [county], r9d  
    jmp poll_loop

_l:
    mov r9d, dword [county]
    add r9, 1
    mov dword [county], r9d  
    jmp poll_loop

clear_term:
    mov rax, 1
    mov rdi, 1
    mov rsi, clear
    mov rdx, clear_len
    syscall
    ret

print_pos:
    xor r8, r8
    mov r8d, dword [count]
    mov r9d, dword [county]
    cmp r8, 0 
    je loop_col

loop_row:    
    mov rax, 1
    mov rdi, 1
    mov rsi, newline 
    mov rdx, 1
    syscall
    
    dec r8
    cmp r8, 0
    jne loop_row

loop_col:
    cmp r9, 0
    je end_print
    
    mov rax, 1
    mov rdi, 1
    mov rsi, space
    mov rdx, 1
    syscall
    
    dec r9
    jmp loop_col
    
end_print: 
    mov rax, 1
    mov rdi, 1
    mov rsi, x
    mov rdx, 1
    syscall
    ret
    
exit_program:
    mov rax, 60                 
    xor rdi, rdi                
    syscall
