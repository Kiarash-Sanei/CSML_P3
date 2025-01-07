section .text
    global DPTIMC
    DPTIMC:                    ; Calculate trace of product of two matrices using SIMD
        push rbp
        mov rbp, rsp
        
        ; Save registers
        push r12
        push r13
        push r14
        push r15
        
        ; Initialize registers
        xor rax, rax          ; rax = 0 (final trace accumulator)
        xor r12, r12          ; r12 = current diagonal position
        
        ; Calculate how many elements we can process in parallel
        mov r13, rsi          ; r13 = number of columns
        shr r13, 2            ; divide by 4 (process 4 integers at once)
        
    trace_loop:
        cmp r12d, edi         ; Compare with number of rows
        jge end_calc          ; If finished all diagonals, end
        
        ; Initialize vector accumulator for current diagonal element
        pxor xmm0, xmm0       ; Clear accumulator for dot product
        xor r14, r14          ; r14 = column counter (for vector operations)
        
    vector_loop:
        cmp r14, r13          ; Check if we can do more vector operations
        jge handle_remainder
        
        ; Calculate base offsets for current row
        mov r15, r12          ; Current row
        imul r15, rsi         ; Multiply by number of columns
        add r15, r14          ; Add vector start position
        shl r15, 2            ; Multiply by 4 (sizeof(int))
        lea rbx, [r15 + 16]   ; End of current vector (4 integers)
        
        ; Load 4 integers from each matrix
        movdqu xmm1, [rdx + r15]  ; Load from matrix1
        movdqu xmm2, [rcx + r15]  ; Load from matrix2
        
        ; Multiply and accumulate
        pmulld xmm1, xmm2         ; Multiply vectors
        paddd xmm0, xmm1          ; Add to accumulator
        
        inc r14                   ; Move to next vector position
        jmp vector_loop
        
    handle_remainder:
        ; Handle remaining elements
        mov r14d, r13d
        shl r14d, 2               ; Convert back to actual position
        
    remainder_loop:
        cmp r14d, esi             ; Check if we're done with this row
        jge end_row
        
        ; Calculate offset for single element
        mov r15, r12              ; Current row
        imul r15, rsi             ; Multiply by columns
        add r15, r14              ; Add current position
        shl r15, 2                ; Multiply by 4
        
        ; Process single element
        mov ebx, [rdx + r15]      ; Get element from matrix1
        imul ebx, [rcx + r15]     ; Multiply with element from matrix2
        pxor xmm1, xmm1           ; Clear temporary register
        movd xmm1, ebx            ; Move result to vector register
        paddd xmm0, xmm1          ; Add to accumulator
        
        inc r14                   ; Move to next element
        jmp remainder_loop
        
    end_row:
        ; Horizontal sum of vector accumulator
        pshufd xmm1, xmm0, 0x0E   ; Shuffle high dwords to low
        paddd xmm0, xmm1          ; Add
        pshufd xmm1, xmm0, 0x01   ; Shuffle remaining dwords
        paddd xmm0, xmm1          ; Add
        movd ebx, xmm0            ; Extract result
        add eax, ebx              ; Add to final trace
        
        inc r12                   ; Move to next diagonal
        jmp trace_loop
        
    end_calc:
        ; Restore registers
        pop r15
        pop r14
        pop r13
        pop r12
        
        leave
        ret

section .note.GNU-stack