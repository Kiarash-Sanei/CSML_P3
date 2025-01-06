extern RF                 ; External reference to RF (Read Float) function

section .text
    global RFM
    RFM:                 ; Read Float Matrix function
                        ; Parameters:
                        ; rdi -> n (number of rows)
                        ; rsi -> m (number of columns)
                        ; rdx -> matrix pointer (where to store the matrix)
        push rbp
        mov rbp, rsp
        sub rsp, 32      ; Allocate 32 bytes of stack space

        push rbx         ; Preserve rbx as we'll use it to store total elements (n*m)
        push r12         ; Preserve r12 as we'll use it as loop counter

        mov rbx, rdi     ; Move n (rows) to rbx
        imul rbx, rsi    ; Calculate total elements: rbx = n * m
        xor r12, r12     ; Initialize counter (i) to 0

        input_loop:      ; Loop to read each matrix element
            push rdi     ; Save registers that might be modified by RF call
            push rdx     ; Save matrix pointer
            
            ; Calculate address of current matrix element:
            ; matrix[i] = base_address + i * 8 (8 bytes per float)
            lea rsi, [rdx + r12 * 8]  ; Load effective address for current element
            call RF      ; Read one float using RF function
            
            pop rdx      ; Restore saved registers
            pop rdi
            inc r12      ; Increment counter
            cmp r12, rbx ; Compare counter with total elements
            jl input_loop ; If counter < total elements, continue loop

        pop r12          ; Restore preserved registers
        pop rbx
        
        mov rax, 0       ; Return 0 (success)
        add rsp, 32      ; Clean up stack
        leave
        ret

section	.note.GNU-stack  ; Mark stack as non-executable