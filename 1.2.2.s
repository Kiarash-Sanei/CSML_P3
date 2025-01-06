global asm_main
extern printf
extern scanf

section .text
asm_main:
    ; Setup stack frame
    push rbp
    mov rbp, rsp
    sub rsp, 32                ; Allocate space on stack and align for SIMD operations

    ; Read dimensions n, m, p from input
    mov rdi, scanf_format
    lea rsi, [n]              ; Address of variable n
    xor eax, eax              ; Clear rax before calling scanf (x86-64 ABI requirement)
    call scanf

    mov rdi, scanf_format
    lea rsi, [m]              ; Address of variable m
    xor eax, eax
    call scanf

    mov rdi, scanf_format
    lea rsi, [p]              ; Address of variable p
    xor eax, eax
    call scanf

    ; Calculate total sizes of matrices and check against maximum limit
    mov eax, DWORD [n]
    imul eax, DWORD [m]        ; Calculate size of first matrix (n*m)
    mov DWORD [size1], eax
    cmp eax, DWORD [max]
    jg big_size_error          ; Jump if size exceeds max allowed

    mov eax, DWORD [m]
    imul eax, DWORD [p]        ; Calculate size of second matrix (m*p)
    mov DWORD [size2], eax
    cmp eax, DWORD [max]
    jg big_size_error          ; Jump if size exceeds max allowed

    mov eax, DWORD [n]
    imul eax, DWORD [p]        ; Calculate size of result matrix (n*p)
    mov DWORD [size3], eax
    cmp eax, DWORD [max]
    jg big_size_error          ; Jump if size exceeds max allowed

    ; Read elements of first matrix from input
    xor r12, r12               ; Index for elements
    input_loop1:
        mov rdi, scanf_float_format
        lea rsi, [matrix1 + r12 * 4] ; Address of current element in matrix1
        xor eax, eax
        call scanf
        inc r12
        cmp r12d, DWORD [size1]
        jl input_loop1         ; Continue until all elements are read

    ; Read elements of second matrix from input
    xor r12, r12               ; Reset index
    input_loop2:
        mov rdi, scanf_float_format
        lea rsi, [matrix2 + r12 * 4] ; Address of current element in matrix2
        xor eax, eax
        call scanf
        inc r12
        cmp r12d, DWORD [size2]
        jl input_loop2         ; Continue until all elements are read

    ; Perform matrix multiplication using SIMD (AVX instructions)
    xor r12, r12               ; i = 0 (row index of first matrix)
    outer_multiplication_loop:
        xor r13, r13           ; j = 0 (column index of second matrix)
        middle_multiplication_loop:
            ; Initialize SIMD accumulator to zero
            vxorps ymm0, ymm0, ymm0   ; Clear YMM register (8 floats at once)

            xor r14, r14               ; k = 0
            inner_multiplication_loop:
                ; Calculate base indices for current elements
                mov eax, r12d                 ; Row index of matrix1
                imul eax, DWORD [m]           ; Multiply by columns of matrix1
                add eax, r14d                 ; Add column index (k)
                shl eax, 2                    ; Convert to byte offset (4 bytes per float)

                mov ebx, r14d                 ; Row index of matrix2
                imul ebx, DWORD [p]           ; Multiply by columns of matrix2
                add ebx, r13d                 ; Add column index (j)
                shl ebx, 2                    ; Convert to byte offset

                ; Load 8 floats from matrices
                vmovups ymm1, [matrix1 + rax] ; Load 8 floats from matrix1
                vmovups ymm2, [matrix2 + rbx] ; Load 8 floats from matrix2

                ; Multiply and accumulate into ymm0
                vfmadd231ps ymm0, ymm1, ymm2  ; ymm0 = ymm0 + ymm1 * ymm2

                add r14, 8                    ; Move to the next block of 8 elements
                cmp r14d, DWORD [m]           ; Check if end of row reached
                jl inner_multiplication_loop


            ; Perform horizontal sum of accumulated results in ymm0
            vextractf128 xmm1, ymm0, 1       ; Extract upper 128 bits
            addps xmm0, xmm1                 ; Add upper and lower 128-bit halves
            movhlps xmm1, xmm0               ; Move upper 64 bits of xmm0 to xmm1
            addps xmm0, xmm1                 ; Add upper and lower 64-bit parts
            movaps xmm1, xmm0                ; Copy xmm0 to xmm1
            shufps xmm1, xmm1, 1             ; Shuffle to get the last element
            addss xmm0, xmm1                 ; Add final two elements


            ; Store final result in result matrix
            mov rax, r12                     ; r12 = row index (i)
            imul eax, DWORD [p]              ; Multiply by number of columns in result matrix
            add rax, r13                     ; Add column index (j)
            movss [matrix3 + rax * 4], xmm0  ; Store the final result


            inc r13
            cmp r13d, DWORD [p]
            jl middle_multiplication_loop    ; Continue until all columns processed

        inc r12
        cmp r12d, DWORD [n]
        jl outer_multiplication_loop         ; Continue until all rows processed
    mov rdi, newline_format              ; Print newline after each row
    xor eax, eax
    call printf
    ; Print the resulting matrix
    xor r12, r12               ; i = 0
    outer_print_loop:
        xor r13, r13           ; j = 0
        inner_print_loop:
            mov rax, r12
            imul eax, DWORD [p]
            add rax, r13
            movss xmm0, [matrix3 + rax * 4]  ; Load result element
            cvtss2sd xmm0, xmm0 ; convert float to double
            mov rdi, printf_float_format
            call printf

            inc r13
            cmp r13d, DWORD [p]
            jl inner_print_loop              ; Print next column

        mov rdi, newline_format              ; Print newline after each row
        xor eax, eax
        call printf

        inc r12
        cmp r12d, DWORD [n]
        jl outer_print_loop                  ; Print next row

    ; Cleanup and return success
    vzeroupper                               ; Clear YMM state for non-AVX context
    mov eax, 0                               ; Return success
    leave                                    ; Restore stack frame
    ret

size_error:
    ; Handle case where matrix size exceeds maximum allowed
    mov rdi, error_msg
    xor eax, eax
    call printf
    mov eax, 1                               ; Return error code
    leave
    ret

section .data
    scanf_format: db "%d", 0                 ; Format for reading integers
    scanf_float_format: db "%f", 0           ; Format for reading floats
    printf_float_format: db "%.2f ", 0         ; Format for printing floats
    newline_format: db 10, 0                 ; Newline character
    error_msg: db "Size of matrix is bigger than expected! The number of elements in matrices must be less than 10000.", 10, 0
    max: dd 10000                            ; Maximum allowed size for any matrix

section .bss
    alignb 32                                ; Align data for AVX operations
    n: resd 1                                ; Number of rows in first matrix
    m: resd 1                                ; Number of columns in first matrix / rows in second matrix
    p: resd 1                                ; Number of columns in second matrix
    size1: resd 1                            ; Size of first matrix (n * m)
    size2: resd 1                            ; Size of second matrix (m * p)
    size3: resd 1                            ; Size of result matrix (n * p)
    matrix1: resd 10000                      ; Storage for first matrix
    matrix2: resd 10000                      ; Storage for second matrix
    matrix3: resd 10000                      ; Storage for result matrix
