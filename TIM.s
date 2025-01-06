section .text
    global TIM
    TIM: ; Transpose Integer Matrix (rdi -> n, rsi -> m, rdx -> matrix1 pointer, rcx -> matrix2 pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        push r12
        push r13
        push r14

        ; Transpose matrix1 and store in matrix2
        xor r12, r12              ; Initialize row counter for transposing
        transpose_outer_loop:
            xor r13, r13          ; Initialize column counter for transposing
            transpose_inner_loop:
                ; Calculate source index (i * m + j)
                mov rax, r12              ; Load row index
                imul rax, rsi       ; Multiply by number of columns
                add rax, r13              ; Add column index

                ; Calculate destination index (j * n + i)
                mov rbx, r13                  ; Load column index
                imul rbx, rdi       ; Multiply by number of rows
                add rbx, r12              ; Add row index

                ; Move element to transposed position
                mov r14d, DWORD [rdx + rax * 4] ; Load element from matrix1
                mov DWORD [rcx + rbx * 4], r14d ; Store in matrix2

                inc r13                   ; Increment column counter
                cmp r13, rsi       ; Check if all columns processed
                jl transpose_inner_loop   ; Continue if not done

            inc r12                   ; Increment row counter
            cmp r12, rdi       ; Check if all rows processed
            jl transpose_outer_loop   ; Continue if not done

        pop r13
        pop r12

        mov rax, 0
        add rsp, 32
        leave
        ret

section	.note.GNU-stack