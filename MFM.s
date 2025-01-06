section .text
    global MFM
    MFM: ; Matrix Float Multiplication (rdi -> n, rsi -> m, rdx -> p, rcx -> matrix1 pointer, r8 -> matrix2 pointer, r9 -> matrix3 pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        push r12 ; Preserve callee-saved registers
        push r13
        push r14

        ; Perform matrix multiplication: matrix3[i][j] = Σ(matrix1[i][k] * matrix2[k][j])
        xor r12, r12              ; i = 0 (row index of first matrix)
        outer_multiplication_loop:
            xor r13, r13          ; j = 0 (column index of second matrix)
            middle_multiplication_loop:
                xor r14, r14      ; k = 0 (column index of first matrix/row index of second matrix)
                xorps xmm0, xmm0       ; Initialize sum for current element
                inner_multiplication_loop:
                    ; Calculate index for matrix1[i][k]
                    mov rax, r12
                    imul rax, rsi
                    add rax, r14
                    shl rax, 3
                    add rax, rcx
                    movss xmm1, [rax]

                    ; Calculate index for matrix2[k][j]
                    mov rax, r14
                    imul rax, rdx
                    add rax, r13
                    shl rax, 3
                    add rax, r8
                    movss xmm2, [rax]

                    ; Multiply and accumulate
                    mulss xmm1, xmm2
                    addss xmm0, xmm1

                    ; Move to next element in row/column
                    inc r14
                    cmp r14, rsi
                    jl inner_multiplication_loop

                ; Store result in matrix3[i][j]
                mov rax, r12
                imul rax, rdx
                add rax, r13
                shl rax, 3
                add rax, r9
                movss [rax], xmm0

                inc r13                    ; Move to next column in result
                cmp r13, rdx
                jl middle_multiplication_loop

            inc r12                        ; Move to next row in result
            cmp r12, rdi
            jl outer_multiplication_loop


        pop r14 ; Restore callee-saved registers
        pop r13
        pop r12

        mov rax, 0
        add rsp, 32
        leave
        ret

section	.note.GNU-stack