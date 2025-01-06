extern scanf                           ; Declare external C function scanf

section .data
    scanf_format: db "%f", 0           ; Format string for reading floats

section .text
    global RF
    RF: ; Read Float (rsi -> float pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        mov rdi, scanf_format          ; First argument: format string
        call scanf                     ; Call scanf to read float

        mov rax, 0
        add rsp, 32
        leave
        ret

section	.note.GNU-stack