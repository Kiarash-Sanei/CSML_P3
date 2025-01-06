extern printf

section .data
    printf_format: db "%d ", 0         ; Format for printing integers with space
    newline_format: db 10, 0           ; Newline character

section .text
    global PIM
    PIM: ; Print Integer Matrix (rdi -> n, rsi -> m, rdx -> matrix pointer)
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
                ; Calculate offset: matrix[i][j] = base + (i * m + j) * 4
                mov rax, r12      ; rax = i
                imul rax, r14     ; rax = i * m
                add rax, r13      ; rax = i * m + j
                
                push rdi ; Save registers that printf might modify
                push rsi
                push rdx

                mov esi, DWORD [rdx + rax * 4]  ; Get matrix[i][j]
                mov rdi, printf_format
                call printf                      ; Print the number

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
            mov rdi, newline_format
            call printf

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