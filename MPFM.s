section .text
    global MPFM
    MPFM: ; Matrix Parallel Float Multiplication (rdi -> n, rsi -> m, rdx -> p, rcx -> matrix1 pointer, r8 -> matrix2 pointer, r9 -> matrix3 pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        push r12 ; Preserve callee-saved registers
        push r13
        push r14
        push r15

        ; Perform matrix multiplication using SIMD
        xor r12, r12              ; i = 0 (row index of first matrix)
    outer_multiplication_loop:
        xor r13, r13              ; j = 0 (column index of second matrix)
    middle_multiplication_loop:
        xor r14, r14              ; k = 0 (column index of first matrix/row index of second matrix)
        xorps xmm0, xmm0          ; Initialize sum for current element
        
        ; Calculate how many 4-float blocks we can process
        mov r15, rsi
        shr r15, 2                ; Divide by 4 to get number of full vector operations
        
        ; Vector processing loop
    vector_multiplication_loop:
        cmp r14, r15
        jge scalar_remainder_loop
        
        ; Load 4 elements from matrix1[i][k:k+4]
        mov rax, r12
        imul rax, rsi
        lea rax, [rax + r14*4]    ; Multiply k by 4 since we're processing 4 elements
        shl rax, 3                ; Multiply by 8 for float size
        add rax, rcx
        movups xmm1, [rax]        ; Load 4 floats from matrix1
        
        ; Load 4 elements from matrix2[k:k+4][j]
        mov rax, r14
        shl rax, 2                ; Multiply k by 4
        imul rax, rdx
        add rax, r13
        shl rax, 3
        add rax, r8
        movups xmm2, [rax]        ; Load 4 floats from matrix2
        
        ; Multiply and accumulate using SIMD
        mulps xmm1, xmm2
        haddps xmm1, xmm1         ; Horizontal add
        haddps xmm1, xmm1
        addss xmm0, xmm1          ; Add to accumulator
        
        add r14, 4                ; Move to next 4 elements
        jmp vector_multiplication_loop
        
    scalar_remainder_loop:
        ; Handle remaining elements one by one
        mov r14, r15
        shl r14, 2                ; Convert back to actual index
    scalar_loop:
        cmp r14, rsi
        jge end_inner_loop
        
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
        
        inc r14
        jmp scalar_loop
        
    end_inner_loop:
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
        
        inc r12                    ; Move to next row in result
        cmp r12, rdi
        jl outer_multiplication_loop
        
        pop r15
        pop r14                    ; Restore callee-saved registers
        pop r13
        pop r12
        
        mov rax, 0
        add rsp, 32
        leave
        ret

section	.note.GNU-stack