section .text
    global TIM
    TIM: ; Transpose Integer Matrix (rdi -> n, rsi -> m, rdx -> matrix1 pointer, rcx -> matrix2 pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        push r12 ; Preserve callee-saved registers
        push r13
        push r14

        ; Transpose matrix1 and store in matrix2
        xor r12, r12            ; r12 = 0 (row index i)
        transpose_outer_loop:
            xor r13, r13        ; r13 = 0 (column index j)
            transpose_inner_loop:
                ; Calculate source index (i * m + j) for matrix1[i][j]
                mov rax, r12            ; rax = i
                imul rax, rsi          ; rax = i * m (multiply by number of columns)
                add rax, r13           ; rax = i * m + j (final source index)

                ; Calculate destination index (j * n + i) for matrix2[j][i]
                mov rbx, r13           ; rbx = j
                imul rbx, rdi          ; rbx = j * n (multiply by number of rows)
                add rbx, r12           ; rbx = j * n + i (final destination index)

                ; Perform the transpose operation
                mov r14d, DWORD [rdx + rax * 4]    ; Load element from matrix1[i][j]
                mov DWORD [rcx + rbx * 4], r14d    ; Store in matrix2[j][i]

                ; Inner loop control
                inc r13                ; j++
                cmp r13, rsi          ; Compare j with m (number of columns)
                jl transpose_inner_loop ; If j < m, continue inner loop

            ; Outer loop control
            inc r12                    ; i++
            cmp r12, rdi              ; Compare i with n (number of rows)
            jl transpose_outer_loop    ; If i < n, continue outer loop

        pop r13 ; Restore callee-saved registers
        pop r12

        mov rax, 0
        add rsp, 32
        leave
        ret

section	.note.GNU-stack