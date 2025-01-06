section .text
    global TIMC
    TIMC: ; Trace Integer Matrix Calculator (rdi -> n, rsi -> matrix pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        push r12

        xor rax, rax              ; Initialize trace accumulator
        xor r12, r12              ; Initialize loop counter
        trace_loop:
            ; Calculate and add diagonal element matrix[i][i]
            mov rbx, r12          ; Load current index
            imul rbx, rdi         ; Multiply by number of columns (n)
            add rbx, r12          ; Add column index to get diagonal element
            mov edx, DWORD [rsi + rbx * 4] ; Load diagonal element
            add eax, edx          ; Add to trace

            inc r12               ; Move to next diagonal element
            cmp r12, rdi         ; Compare with n (matrix size)
            jl trace_loop        ; Continue if not done

        pop r12

        add rsp, 32
        leave
        ret

section	.note.GNU-stack