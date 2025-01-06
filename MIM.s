section .text
    global MIM
    MIM: ; Matrix Integer Multiplication (rdi -> n, rsi -> m, rdx -> p, rcx -> matrix1 pointer, r8 -> matrix2 pointer, r9 -> matrix3 pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        push r12 ; Preserve callee-saved registers
        push r13
        push r14
        push r15

        ; Perform matrix multiplication: matrix3[i][j] = Σ(matrix1[i][k] * matrix2[k][j])
        xor r12, r12              ; i = 0 (row index of first matrix)
        outer_multiplication_loop:
            xor r13, r13          ; j = 0 (column index of second matrix)
            middle_multiplication_loop:
                xor r14, r14      ; k = 0 (column index of first matrix/row index of second matrix)
                xor r15, r15      ; Initialize sum for current element matrix3[i][j]
                inner_multiplication_loop:
                    ; Calculate index for matrix1[i][k]: index = i * m + k
                    mov rax, r12   ; rax = i
                    imul rax, rsi  ; rax = i * m
                    add rax, r14   ; rax = i * m + k
                    mov ebx, DWORD [rcx + rax * 4]  ; ebx = matrix1[i][k]

                    ; Calculate index for matrix2[k][j]: index = k * p + j
                    mov rax, r14   ; rax = k
                    imul rax, rdx  ; rax = k * p
                    add rax, r13   ; rax = k * p + j
                    imul ebx, DWORD [r8 + rax * 4]  ; ebx = matrix1[i][k] * matrix2[k][j]

                    ; Add to running sum
                    add r15d, ebx  ; sum += matrix1[i][k] * matrix2[k][j]

                    ; Move to next element in row/column
                    inc r14        ; k++
                    cmp r14, rsi   ; Compare k with m
                    jl inner_multiplication_loop

                ; Store result in matrix3[i][j]: index = i * p + j
                mov rax, r12       ; rax = i
                imul rax, rdx      ; rax = i * p
                add rax, r13       ; rax = i * p + j
                mov DWORD [r9 + rax * 4], r15d  ; matrix3[i][j] = sum

                inc r13           ; j++
                cmp r13, rdx      ; Compare j with p
                jl middle_multiplication_loop

            inc r12               ; i++
            cmp r12, rdi         ; Compare i with n
            jl outer_multiplication_loop

        pop r15 ; Restore callee-saved registers
        pop r14
        pop r13
        pop r12

        mov rax, 0
        add rsp, 32
        leave
        ret

section	.note.GNU-stack