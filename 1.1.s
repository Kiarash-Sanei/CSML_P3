global asm_main
extern printf
extern scanf
section .text
asm_main:
    sub rsp, 8                 ; Align stack and make room for local variables

    ; Read dimensions n, m, p from input
    mov rdi, scanf_format
    lea rsi, [n]
    xor eax, eax
    call scanf
    mov rdi, scanf_format
    lea rsi, [m]
    xor eax, eax
    call scanf
    mov rdi, scanf_format
    lea rsi, [p]
    xor eax, eax
    call scanf

    ; Calculate total sizes of matrices and check against maximum limit
    mov eax, DWORD [n]
    imul eax, DWORD [m]        ; Calculate size of first matrix (n*m)
    mov DWORD [size1], eax
    cmp eax, DWORD [max]       ; Check if size exceeds maximum allowed
    jg size_error

    mov eax, DWORD [m]
    imul eax, DWORD [p]        ; Calculate size of second matrix (m*p)
    mov DWORD [size2], eax
    cmp eax, DWORD [max]       ; Check if size exceeds maximum allowed
    jg size_error

    mov eax, DWORD [n]
    imul eax, DWORD [p]        ; Calculate size of result matrix (n*p)
    mov DWORD [size3], eax
    cmp eax, DWORD [max]       ; Check if size exceeds maximum allowed
    jg size_error

    ; Read elements of first matrix
    xor r12, r12             ; Initialize counter
    input_loop1:
        mov rdi, scanf_format
        lea rsi, [matrix1 + r12 * 4]    ; Calculate address of current element
        xor eax, eax
        call scanf
        inc r12                         ; Move to next element
        cmp r12d, DWORD [size1]
        jl input_loop1                  ; Continue until all elements are read

    ; Read elements of second matrix
    xor r12, r12               ; Initialize counter
    input_loop2:
        mov rdi, scanf_format
        lea rsi, [matrix2 + r12 * 4]    ; Calculate address of current element
        xor eax, eax
        call scanf
        inc r12                         ; Move to next element
        cmp r12d, DWORD [size2]
        jl input_loop2                  ; Continue until all elements are read

    ; Perform matrix multiplication: matrix3[i][j] = Σ(matrix1[i][k] * matrix2[k][j])
    xor r12, r12              ; i = 0 (row index of first matrix)
    outer_multiplication_loop:
        xor r13, r13          ; j = 0 (column index of second matrix)
        middle_multiplication_loop:
            xor r14, r14      ; k = 0 (column index of first matrix/row index of second matrix)
            xor r15, r15      ; Initialize sum for current element
            inner_multiplication_loop:
                ; Calculate index for matrix1[i][k]
                mov rax, r12
                imul eax, DWORD [m]
                add rax, r14
                mov esi, DWORD [matrix1 + rax * 4]

                ; Calculate index for matrix2[k][j]
                mov rax, r14
                imul eax, DWORD [p]
                add rax, r13
                mov edi, DWORD [matrix2 + rax * 4]

                ; Multiply and accumulate
                imul esi, edi
                add r15d, esi

                ; Move to next element in row/column
                inc r14
                cmp r14d, DWORD [m]
                jl inner_multiplication_loop

            ; Store result in matrix3[i][j]
            mov rax, r12
            imul eax, DWORD [p]
            add rax, r13
            mov DWORD [matrix3 + rax * 4], r15d

            inc r13                    ; Move to next column in result
            cmp r13d, DWORD [p]
            jl middle_multiplication_loop

        inc r12                        ; Move to next row in result
        cmp r12d, DWORD [n]
        jl outer_multiplication_loop

    ; Print the resulting matrix
    xor r12, r12              ; i = 0 (row counter)
    outer_print_loop:
        xor r13, r13          ; j = 0 (column counter)
        inner_print_loop:
            ; Calculate and print matrix3[i][j]
            mov rax, r12
            imul eax, DWORD [p]
            add rax, r13
            mov esi, DWORD [matrix3 + rax * 4]
            mov rdi, printf_format
            xor eax, eax
            call printf

            inc r13                    ; Move to next column
            cmp r13d, DWORD [p]
            jl inner_print_loop

        ; Print newline after each row
        mov rdi, newline_format
        xor eax, eax
        call printf

        inc r12                        ; Move to next row
        cmp r12d, DWORD [n]
        jl outer_print_loop

    mov eax, 0
    add rsp ,8
    leave
    ret

; Error handler for matrix size exceeded
size_error:
    mov rdi, error_msg
    xor eax, eax
    call printf
    mov eax, 1
    add rsp ,8
    leave
    ret

section .data
    scanf_format: db "%d", 0           ; Format for reading integers
    printf_format: db "%d ", 0         ; Format for printing integers with space
    newline_format: db 10, 0           ; Newline character
    error_msg: db "Size of matrix is bigger than expected!", 10, 0
    max: dd 10000                      ; Maximum allowed matrix size

section .bss
    n: resd 1                          ; Number of rows in first matrix
    m: resd 1                          ; Number of columns in first matrix/rows in second matrix
    p: resd 1                          ; Number of columns in second matrix
    size1: resd 1                      ; Total size of first matrix (n*m)
    size2: resd 1                      ; Total size of second matrix (m*p)
    size3: resd 1                      ; Total size of result matrix (n*p)
    matrix1: resd 10000                ; Storage for first matrix
    matrix2: resd 10000                ; Storage for second matrix
    matrix3: resd 10000                ; Storage for result matrix