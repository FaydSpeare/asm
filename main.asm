extern int_to_string

section .data
    
    SYS_READ equ 0
    SYS_WRITE equ 1
    SYS_POLL equ 7
    SYS_IOCTL equ 16
    SYS_EXIT equ 60
    
    STDIN equ 0
    STDOUT equ 1
    EXIT_OK equ 0
    POLLIN equ 1
    POLL_TIMEOUT equ 100

    CHAR_J equ 106
    CHAR_K equ 107
    CHAR_H equ 104
    CHAR_L equ 108

    ; Some constants to modify terminal configuration
    TCGETS equ 0x5401
    TCSETS equ 0x5402
    
    ; Some constants to help draw the board
    TOP db 10, "+----------------------------------------+"
    ROW db 10, "|                                        |"
    ROW_LEN equ 43
    PLAYER db "P"
    MAX_X equ 40
    MAX_Y equ 10
    
    ; Buffer for clearing the terminal
    CLEAR db 27, "[H", 27, "[2J"
    CLEAR_LEN equ $ - CLEAR
    
    ; Player board position 
    pos_x dd 0
    pos_y dd 0
    
    input_buffer db 1
    INPUT_LEN equ 1

    pollfd:
        fd dd 0
        events dw 1
        revents dw 0

section .text
    global _start

_start:
    call configure_terminal 
    call randomize_pos

game_loop:
    call clear_terminal
    call print_board
    call wait_for_input 
    call read_input

handle_input: 
    cmp byte [input_buffer], CHAR_J
    je move_down
    cmp byte [input_buffer], CHAR_K
    je move_up
    cmp byte [input_buffer], CHAR_H
    je move_left
    cmp byte [input_buffer], CHAR_L
    je move_right
    jmp game_loop

move_up:
    mov r8d, dword [pos_y]
    sub r8, 1
    mov edx, 0
    cmovs r8d, edx
    mov dword [pos_y], r8d
    jmp game_loop

move_down:
    mov r8d, dword [pos_y]
    add r8, 1
    cmp r8, MAX_Y-1
    mov edx, MAX_Y-1
    cmovg r8d, edx
    mov dword [pos_y], r8d  
    jmp game_loop

move_left:
    mov r9d, dword [pos_x]
    sub r9, 1
    mov edx, 0
    cmovs r9d, edx
    mov dword [pos_x], r9d  
    jmp game_loop

move_right:
    mov r9d, dword [pos_x]
    add r9, 1
    cmp r9, MAX_X-1
    mov edx, MAX_X-1
    cmovg r9d, edx
    mov dword [pos_x], r9d  
    jmp game_loop

randomize_pos:
    call rand2
    rol ebx, 2 ; x 4
    mov dword [pos_y], eax
    mov dword [pos_x], ebx 
    ret 

wait_for_input:
    ; Clear the space to be filled in by SYS_POLL
    mov word [revents], 0 

    mov rax, SYS_POLL
    mov rsi, 1             ; Polling 1 file descriptor
    mov rdi, pollfd
    mov rdx, POLL_TIMEOUT
    syscall
    
    ; Check if there is data to read 
    cmp word [revents], POLLIN
    jne wait_for_input
    ret

clear_terminal:
    mov rax, 1
    mov rdi, 1
    mov rsi, CLEAR
    mov rdx, CLEAR_LEN
    syscall
    ret

print_row:
    push rbp
    mov rbp, rsp
    sub rsp, ROW_LEN
    
    lea rsi, ROW
    lea rdi, [rbp-ROW_LEN]
    mov rcx, ROW_LEN 
    rep movsb
    
    mov ebx, dword [pos_y]
    cmp ebx, eax
    jne finish_print_row

    mov eax, dword [pos_x]
    lea rsi, PLAYER
    lea rdi, [rbp-ROW_LEN+2]
    add rdi, rax
    mov rcx, 1
    rep movsb

finish_print_row: 
    lea rsi, [rbp-ROW_LEN]
    mov rdx, ROW_LEN
    call print

    mov rsp, rbp
    pop rbp
    ret

print_board:
    push rbp
    mov rbp, rsp

    mov rsi, TOP
    mov rdx, ROW_LEN
    call print
    
    mov rax, 0
loop_print_row:
    push rax
    call print_row
    pop rax
    inc rax
    cmp rax, 10
    jl loop_print_row
    
    mov rsi, TOP
    mov rdx, ROW_LEN
    call print
    
    mov rsp, rbp
    pop rbp
    ret
 
exit_program:
    mov rax, SYS_EXIT            
    mov rdi, EXIT_OK               
    syscall

print:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    syscall
    ret

read_input:
    mov rax, SYS_READ
    mov rdi, STDIN
    mov rsi, input_buffer
    mov rdx, INPUT_LEN
    syscall

; Function which sets up the terminal so that keys
; can be read from STDIN without waiting for an <ENTER>
; key press.
configure_terminal:
    push rbp
    mov rbp, rsp

    ; Allocate space on the stack for the termios struct
    ; Not exactly sure how large the termios struct is, 
    ; it seems to vary. But 36 bytes seems to be enough,
    ; and we only want to edit the c_lflag which is 12
    ; bytes from the start of the struct.
    sub rsp, 36
    
    ; Get current settings
    mov eax, SYS_IOCTL
    mov edi, STDIN
    mov esi, TCGETS
    lea rdx, [rbp-36]
    syscall

    ; Need to disable cononical mode by clearing ICANON, so we
    ; unset the second bit in the c_lflag of termios struct
    ; https://man7.org/linux/man-pages/man3/termios.3.html
    and byte [rbp-24], 0b11111101

    ; Write termios structure back
    mov eax, SYS_IOCTL
    mov edi, STDIN
    mov esi, TCSETS
    lea rdx, [rbp-36]
    syscall
   
    mov rsp, rbp
    pop rbp
    ret

; Function to return two 'random' digits from 0-9.
; These two digits come from the two least significant
; digits of the microseconds return by the sys_gettimeofday call.
; The two digits are return in rax and rbx.
rand2:
    push rbp        ; save the initial base ptr
    mov rbp, rsp    ; save the stack ptr
    sub rsp, 16     ; allocate space for 32 bytes on the stack

    mov rax, 96          ; sys_gettimeofday
    lea rdi, [rbp-16]    ; pass in ptr to 16 bytes (for storing result)
    syscall         
    
    xor rdx, rdx       ; make sure rdx is clear (for remainder)
    mov rax, [rbp-8]   ; move the microseconds into rax to be divided
    mov ecx, 10
    div ecx            ; divide the microseconds by 10
    push rdx           ; use remainder as random number 1
 
    xor rdx, rdx       ; make sure rdx is clear (for remaineder) 
    mov ecx, 10
    div ecx            ; divide the result by 10 again
    push rdx           ; use the remainder as random number 2
    
    ; store the results in rax and rbx
    pop rax
    pop rbx

    mov rsp, rbp    ; deallocate space made on the stack
    pop rbp         ; restore the initial base ptr
    ret
