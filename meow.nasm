    global    _start

    section   .text

meow:
    mov rax, 1
    mov rdi, 1
    mov rsi, input_buf,
    mov rdx, 13
    syscall
    ret

swap_case:
    cmp rdi, 'a'
    jge check_lowercase_2
failed_0:
    cmp rdi, 'A'
    jge check_uppercase_2
failed_1:
    mov rax, 0
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

next_char:
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
    mov rax, 'Z'
    ret


process_next:
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
    mov       rax, 0                  ; system call for write
    mov       rdi, 0                  ; file handle 1 is stdout
    mov       rsi, input_buf            ; address of string to output
    mov       rdx, buf_size                 ; number of bytes
    syscall                           ; invoke operating system to do the write

    mov rbx, rax  ; Grab the length of the input
    sub rbx, 1   ; Iterate for len - 1
    mov r13, 0  ;  0...N iterator for loop
    mov dword [result_buf], 'M'  ; Store the first seed value ('M')
    mov r15, 1  ; 1...N+1 iterator for the loop
loop_i:
    mov r8, 4  ; Iterate the inner loop 4 times
loop_j:
    mov r9, [input_buf + r13]  ; Grab the input character
    mov r10, r8  ; Grab the loop counter to calculate the shift
    imul r10, 2  ; shift == loop_i * 2 - 2
    add r10, -2
    mov rcx, r10  ; Shift the read char by r10
    shr r9, cl
    and r9, 0b11  ; Trim off everything except the last 2 bits

    mov r14, r15
    sub r14, 1
    mov rdi, [result_buf + r14]  ; Grab previous character
    mov rsi, r9 ; b
    call process_next
    mov [result_buf + r15], rax
    inc r15

    dec r8
    cmp r8, 0
    jnz loop_j

    inc r13
    
    dec rbx
    cmp rbx, 0
    jnz loop_i

    ; Print out result_buf
    mov rax, 1
    mov rdi, 1
    mov rsi, result_buf
    mov rdx, result_size
    syscall
    
    ; Exit
    mov       rax, 60                 ; system call for exit
    xor       rdi, rdi                ; exit code 0
    syscall                           ; invoke operating system to exit

    section   .data

result_buf:          times 255 db 0
result_size:          equ $ - result_buf
input_buf:          times 255 db 0
buf_size:           equ $ - input_buf     ; calculate the offset to `input_buf`