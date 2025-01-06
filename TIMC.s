section .text
    global TIMC
    TIMC: ; Trace Integer Matrix Calculator (rdi -> n, rsi -> matrix pointer)
        push rbp
        mov rbp, rsp
        sub rsp, 32


        push r12                 ; Preserve r12 register as we'll use it

        ; Initialize registers
        xor rax, rax            ; rax = 0 (will hold the trace sum)
        xor r12, r12            ; r12 = 0 (loop counter i)

        trace_loop:
            ; Calculate the index of diagonal element at position [i][i]
            mov rbx, r12         ; rbx = i
            imul rbx, rdi        ; rbx = i * n (multiply by number of columns)
            add rbx, r12         ; rbx = i * n + i (add column index)
            
            ; Load and add diagonal element to trace
            mov edx, DWORD [rsi + rbx * 4]  ; Load matrix[i][i] (4 bytes per integer)
            add eax, edx                    ; Add to running sum in rax

            ; Loop control
            inc r12              ; i++
            cmp r12, rdi         ; Compare i with n (matrix size)
            jl trace_loop        ; If i < n, continue loop

        pop r12                  ; Restore preserved register

        add rsp, 32
        leave
        ret

section	.note.GNU-stack