extern scanf                           ; Declare external C function scanf

section .data
    scanf_format: db "%d", 0           ; Format string for reading integers

section .text
    global RI
    RI: ; Read Integer (rsi -> integer pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        mov rdi, scanf_format          ; First argument: format string
        call scanf                     ; Call scanf to read integer

        mov rax, 0
        add rsp, 32
        leave
        ret

section	.note.GNU-stack