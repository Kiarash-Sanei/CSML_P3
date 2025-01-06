; External functions declaration
extern printf

section .data
    ; Error message for when matrix size exceeds maximum
    error: db "Size of matrix is bigger than expected!", 10, 0

section .text
    global CMS
    CMS: ; Check Maximum Size (rdi -> n, rsi -> m, rdx -> max)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        ; Calculate total size of matrix (n * m)
        imul rdi, rsi      ; Multiply rows by columns
        cmp rdi, rdx       ; Compare calculated size with maximum allowed
        jg size_error      ; Jump to error handler if size is greater

        mov rax, 0
        add rsp, 32
        leave
        ret
        
        size_error:        ; Error handler for matrix size exceeded
            mov rdi, error
            call printf
            mov rax, 1
            add rsp, 32
            leave
            ret

section	.note.GNU-stack