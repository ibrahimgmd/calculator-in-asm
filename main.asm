section .bss
num1 resb 5
num2 resb 5
result_buffer resb 20

section .data
input1 db 'first number: ', 0
input1_len equ $ - input1
input2 db 'second number: ', 0
input2_len equ $ - input2
result db 'result: ', 0
result_len equ $ - result
newline db 0xA

section .text
global _start
_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, input1
    mov rdx, input1_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, num1
    mov rdx, 5
    syscall

    xor rax, rax
    xor rcx, rcx
.convert_num1:
    mov bl, [num1 + rcx]
    cmp bl, 0xA
    je .done_num1
    sub bl, '0'
    imul rax, rax, 10
    add rax, rbx
    inc rcx
    jmp .convert_num1
.done_num1:
    mov r8, rax

    mov rax, 1
    mov rdi, 1
    mov rsi, input2
    mov rdx, input2_len
    syscall

    mov rax, 0
    mov rdi, 0
    mov rsi, num2
    mov rdx, 5
    syscall

    xor rax, rax
    xor rcx, rcx
.convert_num2:
    mov bl, [num2 + rcx]
    cmp bl, 0xA
    je .done_num2
    sub bl, '0'
    imul rax, rax, 10
    add rax, rbx
    inc rcx
    jmp .convert_num2
.done_num2:
    add rax, r8

    mov rdi, result_buffer
    mov rsi, rax
    call int_to_ascii

    mov rax, 1
    mov rdi, 1
    mov rsi, result
    mov rdx, result_len
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, result_buffer
    mov rcx, result_buffer
.find_len:
    cmp byte [rcx], 0
    je .got_len
    inc rcx
    jmp .find_len
.got_len:
    mov rdx, rcx
    sub rdx, result_buffer
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

int_to_ascii:
    push rbx
    mov rax, rsi
    cmp rax, 0
    jne .convert
    mov byte [rdi], '0'
    mov byte [rdi+1], 0
    pop rbx
    ret
.convert:
    xor rcx, rcx
.convert_loop:
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add rdx, '0'
    push rdx
    inc rcx
    cmp rax, 0
    jne .convert_loop
.write_loop:
    pop rax
    mov [rdi], al
    inc rdi
    loop .write_loop
    mov byte [rdi], 0
    pop rbx
    ret
