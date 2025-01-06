extern RI

section .text
    global RIM
    RIM: ; Read Integer Matrix (rdi -> n, rsi -> m, rdx -> matrix pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        push rbx           ; Preserve rbx as we'll use it to store total elements (n*m)
        push r12          ; Preserve r12 as we'll use it as counter

        mov rbx, rdi      ; Calculate total number of elements (n*m)
        imul rbx, rsi
        xor r12, r12      ; Initialize counter to 0

        input_loop:       ; Loop to read each matrix element
            push rdi      ; Save rdi before scanf call
            push rdx      ; Save rdx before scanf call
            
            lea rsi, [rdx + r12 * 4]  ; Calculate address for current element
                                      ; matrix[i] = base + i * 4 (4 bytes per int)
            call RI                    ; Read one integer using RI function
            
            pop rdx       ; Restore rdx after scanf
            pop rdi       ; Restore rdi after scanf
            inc r12       ; Increment counter
            cmp r12, rbx  ; Compare counter with total elements
            jl input_loop ; If counter < total elements, continue loop

        pop r12           ; Restore preserved registers
        pop rbx
        
        mov rax, 0
        add rsp, 32
        leave
        ret

section	.note.GNU-stack