global asm_main
extern printf
extern scanf

section .text
asm_main:
    sub rsp, 8                ; Align stack and make room for local variables

    ; Read dimensions n, m from input
    mov rdi, scanf_format     ; Set scanf format for reading integers
    lea rsi, [n]              ; Address of variable 'n'
    xor eax, eax              ; Clear RAX for variadic function
    call scanf

    mov rdi, scanf_format     ; Set scanf format again for 'm'
    lea rsi, [m]              ; Address of variable 'm'
    xor eax, eax              ; Clear RAX
    call scanf

    ; Calculate total size and check against maximum limit
    mov eax, DWORD [n]        ; Load value of 'n'
    imul eax, DWORD [m]       ; Multiply 'n' by 'm' to calculate size
    mov DWORD [size], eax     ; Store the result in 'size'
    cmp eax, DWORD [max]      ; Compare size with maximum allowed limit
    jg size_error             ; Jump to error handling if size exceeds limit

    ; Read elements of first matrix
    xor r12, r12              ; Initialize loop counter for first matrix
    input_loop1:
        mov rdi, scanf_format        ; Set scanf format for input
        lea rsi, [matrix1 + r12 * 4] ; Address of the current element in matrix1
        xor eax, eax                 ; Clear RAX
        call scanf
        inc r12                      ; Increment loop counter
        cmp r12d, DWORD [size]       ; Compare counter with total size
        jl input_loop1               ; Continue loop if counter < size

    ; Read elements of second matrix
    xor r12, r12              ; Reset loop counter for second matrix
    input_loop2:
        mov rdi, scanf_format        ; Set scanf format for input
        lea rsi, [matrix2 + r12 * 4] ; Address of the current element in matrix2
        xor eax, eax                 ; Clear RAX
        call scanf
        inc r12                      ; Increment loop counter
        cmp r12d, DWORD [size]       ; Compare counter with total size
        jl input_loop2               ; Continue loop if counter < size

    ; Transpose matrix1 and store in matrix3
    xor r12, r12              ; Initialize row counter for transposing
    transpose_outer_loop:
        xor r13, r13          ; Initialize column counter for transposing
        transpose_inner_loop:
            ; Calculate source index (i * m + j)
            mov rax, r12              ; Load row index
            imul eax, DWORD [m]       ; Multiply by number of columns
            add rax, r13              ; Add column index

            ; Calculate destination index (j * n + i)
            mov rbx, r13                  ; Load column index
            imul ebx, DWORD [n]       ; Multiply by number of rows
            add rbx, r12              ; Add row index

            ; Move element to transposed position
            mov ecx, DWORD [matrix1 + rax * 4] ; Load element from matrix1
            mov DWORD [matrix3 + rbx * 4], ecx ; Store in matrix3

            inc r13                   ; Increment column counter
            cmp r13d, DWORD [m]       ; Check if all columns processed
            jl transpose_inner_loop   ; Continue if not done

        inc r12                   ; Increment row counter
        cmp r12d, DWORD [n]       ; Check if all rows processed
        jl transpose_outer_loop   ; Continue if not done

    ; Perform matrix multiplication: matrix4[i][j] = Σ(matrix3[i][k] * matrix2[k][j])
    xor r12, r12              ; Initialize row index for result matrix
    outer_multiplication_loop:
        xor r13, r13              ; Initialize column index for result matrix
        middle_multiplication_loop:
            xor r14, r14              ; Initialize summation index (k)
            xor r15, r15              ; Initialize sum accumulator
            inner_multiplication_loop:
                ; Calculate index for matrix3[i][k]
                mov rax, r12              ; Load row index
                imul eax, DWORD [n]       ; Multiply by number of rows
                add rax, r14              ; Add column index (k)
                mov esi, DWORD [matrix3 + rax * 4] ; Load matrix3[i][k]

                ; Calculate index for matrix2[k][j]
                mov rax, r14              ; Load row index (k)
                imul eax, DWORD [m]       ; Multiply by number of columns
                add rax, r13              ; Add column index (j)
                mov edi, DWORD [matrix2 + rax * 4] ; Load matrix2[k][j]

                ; Multiply and accumulate
                imul esi, edi             ; Multiply elements
                add r15d, esi             ; Add to accumulator

                inc r14                   ; Increment index (k)
                cmp r14d, DWORD [m]       ; Check if all columns/rows processed
                jl inner_multiplication_loop ; Continue if not done

            ; Store result in matrix4[i][j]
            mov rax, r12              ; Load row index
            imul eax, DWORD [m]       ; Multiply by number of columns
            add rax, r13              ; Add column index
            mov DWORD [matrix4 + rax * 4], r15d ; Store result

            inc r13                   ; Increment column index
            cmp r13d, DWORD [m]       ; Check if all columns processed
            jl middle_multiplication_loop ; Continue if not done

        inc r12                   ; Increment row index
        cmp r12d, DWORD [m]       ; Check if all rows processed
        jl outer_multiplication_loop ; Continue if not done

    ; Calculate trace of the resulting matrix
    xor rax, rax              ; Initialize trace accumulator
    xor r12, r12              ; Initialize loop counter
    trace_loop:
        ; Calculate and add diagonal element matrix4[i][i]
        mov rbx, r12              ; Load current index
        imul ebx, DWORD [m]       ; Multiply by number of columns
        add rbx, r12              ; Add row index (diagonal element)
        add eax, DWORD [matrix4 + rbx * 4] ; Add to trace

        inc r12                   ; Move to next diagonal element
        cmp r12d, DWORD [m]       ; Check if all diagonal elements processed
        jl trace_loop             ; Continue if not done

    ; Print the trace of the matrix
    mov rdi, printf_format    ; Set format for output
    mov rsi, rax              ; Set trace value as argument
    xor rax, rax              ; Clear RAX for variadic function
    call printf

    mov eax, 0                ; Return 0
    add rsp, 8                ; Restore stack pointer
    ret

size_error:
    mov rdi, error_msg        ; Load error message
    xor eax, eax              ; Clear RAX for variadic function
    call printf               ; Print error message
    mov eax, 1                ; Return error code
    add rsp, 8                ; Restore stack pointer
    ret

section .data
    scanf_format: db "%d", 0
    printf_format: db "%d", 10, 0       ; Format for printing integers
    error_msg: db "Size of matrix is bigger than expected!", 10, 0
    max: dd 10000              ; Maximum allowed size for matrices

section .bss
    n: resd 1                  ; Number of rows
    m: resd 1                  ; Number of columns
    size: resd 1               ; Total size (n*m)
    matrix1: resd 10000        ; First input matrix
    matrix2: resd 10000        ; Second input matrix
    matrix3: resd 10000        ; Transpose of first matrix
    matrix4: resd 10000        ; Storage for result matrix
