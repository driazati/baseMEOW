    global    _start

    section   .text

; Print 'meow' to stdout
meow:
    mov rax, 1
    mov rdi, 1
    mov rsi, meow_msg,
    mov rdx, meow_len
    syscall
    ret

; Swap case of an ascii character (in rdi)
swap_case:
    cmp rdi, 'a'
    jge check_lowercase_2
failed_0:
    cmp rdi, 'A'
    jge check_uppercase_2
failed_1:
    mov rax, 'j'
    ret
check_uppercase_2:
    cmp rdi, 'Z'
    jg failed_1
    add rdi, 'a' - 'A'
    mov rax, rdi 
    ret
check_lowercase_2:
    cmp rdi, 'z'
    jg failed_0
    sub rdi, 'a' - 'A'
    mov rax, rdi
    ret

; Calculate the next char in the sequence via the state machine
next_char:
    and rdi, 0xFF
    cmp rdi, 'm'
    jnz next_0
    mov rax, 'e'
    ret
next_0:
    cmp rdi, 'e'
    jnz next_1
    mov rax, 'o'
    ret
next_1:
    cmp rdi, 'o'
    jnz next_2
    mov rax, 'w'
    ret
next_2:
    cmp rdi, 'w'
    jnz next_3
    mov rax, 'm'
    ret
next_3:
    cmp rdi, 'M'
    jnz next_4
    mov rax, 'E'
    ret
next_4:
    cmp rdi, 'E'
    jnz next_5
    mov rax, 'O'
    ret
next_5:
    cmp rdi, 'O'
    jnz next_6
    mov rax, 'W'
    ret
next_6:
    cmp rdi, 'W'
    jnz next_7
    mov rax, 'M'
    ret
next_7:
    mov rax, '2'
    ret


; Look at bits and dispatch out to swap_case and next_char as necessary
process_next:
    and rsi, 0b11
    cmp rsi, 0b00
    je case_0
    cmp rsi, 0b10
    je case_1
    cmp rsi, 0b01
    je case_2
    cmp rsi, 0b11
    je case_3
    mov rax, 'Z'
    ret
case_0:
    mov rax, rdi
    ret
case_1:
    call swap_case
    ret
case_2:
    call next_char
    mov rdi, rax
    call swap_case
    ret
case_3:
    call next_char
    ret


_start: 
    mov rbx, 'M'  ; last char

    ; Print out first char (M)
    mov [result_buf], rbx
    mov rax, 1
    mov rdi, 1
    mov rsi, result_buf
    mov rdx, 1
    syscall

main_loop2:  
    ; Read the next 'buf_size' chars from stdin
    mov       rax, 0                  ; system call for write
    mov       rdi, 0                  ; file handle 1 is stdout
    mov       rsi, input_buf            ; address of string to output
    mov       rdx, buf_size                 ; number of bytes
    syscall                           ; invoke operating system to do the write

    ; If there's a problem or no new chars, exit
    cmp rax, 0
    jle exit
    cmp rax, buf_size
    jg exit

    mov r12, rax  ; Iterate for as many chars as were in the input
    mov r15, 0    ; Set up an incrementing counter for the char loop
    mov r14, 0    ; Set up an incrementing counter between loops
per_char_loop:
    mov r13, 4  ; Iterate for each 2 bits in the char
per_half_nibble_loop:
    xor r8, r8
    mov r8d, dword [input_buf + r15]  ; Get the input char

    ; Grab only the 2 relevant bits for this loop
    mov rcx, r13
    imul rcx, 2
    add rcx, -2
    shr r8, cl
    and r8, 0b11

    ; Get next char
    mov rdi, rbx  ; Pass the previous char
    mov rsi, r8  ; Pass the 2 bits for the current char
    call process_next

    mov byte [result_buf + r14], al  ; Copy it to the output
    mov rbx, rax  ; Store new prev char

    ; Iterate on inner loop
    dec r13
    inc r14
    cmp r13, 0
    jnz per_half_nibble_loop

    ; Iterate on outer loop
    dec r12
    inc r15
    cmp r12, 0
    jnz per_char_loop

print:
    mov rax, 1
    mov rdi, 1
    mov rsi, result_buf
    mov rdx, r14
    syscall

    jmp main_loop2

exit:
    mov       rax, 60                 ; system call for exit
    xor       rdi, rdi                ; exit code 0
    syscall                           ; invoke operating system to exit

    section   .data

meow_msg: db `MEOW!\n`
meow_len: equ $ - meow_msg
result_buf:     times 128*1024*5 db 0
result_size:     equ $ - result_buf
input_buf:     times 128*1024 db 0
buf_size:      equ $ - input_buf     ; calculate the offset to `input_buf`