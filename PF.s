extern printf                           ; Declare external C function printf

section .data
    printf_format: db "%.2f ", 0           ; Format string for reading floats

section .text
    global PF
    PF: ; Print Float (xmm0 -> float)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        mov rdi, printf_format          ; First argument: format string
        mov eax, 1
        call printf                     ; Call printf to print float

        mov rax, 0
        add rsp, 32
        leave
        ret

section	.note.GNU-stack