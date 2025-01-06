extern printf                           ; Declare external C function printf

section .data
    printf_format: db 10, 0           ; Format string for reading integers

section .text
    global PN
    PN: ; Print Newline
        push rbp
        mov rbp, rsp
        sub rsp, 32

        mov rdi, printf_format          ; First argument: format string
        call printf                     ; Call printf to print newline

        mov rax, 0
        add rsp, 32
        leave
        ret

section	.note.GNU-stack