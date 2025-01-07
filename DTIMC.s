section .text
    global DTIMC
    DTIMC: ; Direct Trace Integer Matrix Calculator (rdi -> n, rsi -> m, rdx -> matrix1 pointer, rcx -> matrix2 pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        push r12
        push r13
        push r14
        push r15

        ; Initialize registers
        xor rax, rax            ; rax = 0 (accumulator for trace sum)
        xor r12, r12            ; r12 = 0 (diagonal index)
        
        trace_loop:
            xor r14, r14        ; Reset dot product accumulator
            xor r13, r13        ; k = 0 (summation index)
            
            dot_product_loop:
                ; Calculate offset for matrix1[k][i]: (k * m + i) * 4
                mov rbx, r13    ; rbx = k
                imul rbx, rsi   ; rbx = k * m
                add rbx, r12    ; rbx = k * m + i
                shl rbx, 2      ; rbx = (k * m + i) * 4
                mov r14d, DWORD [rdx + rbx]  ; Load matrix1[k][i]

                ; Calculate offset for matrix2[k][i]: (k * m + i) * 4
                mov rbx, r13    ; rbx = k
                imul rbx, rsi   ; rbx = k * m
                add rbx, r12    ; rbx = k * m + i
                shl rbx, 2      ; rbx = (k * m + i) * 4
                mov r15d, DWORD [rcx + rbx]  ; Load matrix2[k][i]

                ; Multiply and accumulate
                imul r14d, r15d
                add rax, r14    ; Add to final sum

                ; Loop control for dot product
                inc r13         ; k++
                cmp r13, rdi    ; Compare k with n (rows)
                jl dot_product_loop

            ; Loop control for diagonal elements
            inc r12            ; Move to next diagonal element
            cmp r12, rsi       ; Compare with m (columns)
            jl trace_loop

        pop r15
        pop r14
        pop r13
        pop r12

        add rsp, 32
        leave
        ret

section	.note.GNU-stack