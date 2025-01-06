extern PF
extern PN

section .text
    global PFM
    PFM: ; Print Float Matrix (rdi -> n, rsi -> m, rdx -> matrix pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32

        push r12                    ; Preserve registers we'll use
        push r13
        push r14
    
        mov r14, rsi               ; Store number of columns (m) in r14

        ; Print the matrix row by row
        xor r12, r12              ; i = 0 (row counter)
        outer_print_loop:
            xor r13, r13          ; j = 0 (column counter)
            inner_print_loop:
                ; Calculate offset: matrix[i][j] = base + (i * m + j) * 8
                mov rax, r12      ; rax = i
                imul rax, r14     ; rax = i * m
                add rax, r13      ; rax = i * m + j
                
                push rdi ; Save registers that printf might modify
                push rsi
                push rdx

                movss xmm0, [rdx + rax * 8]  ; Get matrix[i][j]
                cvtss2sd xmm0, xmm0          ; convert float to double
                call PF                      ; Print the number

                pop rdx ; Restore preserved registers
                pop rsi
                pop rdi

                inc r13                    ; j++
                cmp r13, r14              ; if j < m, continue inner loop
                jl inner_print_loop

            
            push rdi
            push rsi
            push rdx
            ; Print newline at end of each row
            call PN

            pop rdx
            pop rsi
            pop rdi

            inc r12                        ; i++
            cmp r12, rdi                  ; if i < n, continue outer loop
            jl outer_print_loop

        pop r14 ; Restore preserved registers
        pop r13
        pop r12    

        mov rax, 0
        add rsp, 32
        leave
        ret

section	.note.GNU-stack