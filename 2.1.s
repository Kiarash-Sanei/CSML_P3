global main
extern RI
extern CMS
extern RIM
extern TIM
extern MIM
extern TIMC
extern PI
extern PN

section .data
    max: dd 10000              ; Maximum allowed size for matrices

section .bss
    n: resd 1                  ; Number of rows
    m: resd 1                  ; Number of columns
    matrix1: resd 10000        ; First input matrix
    matrix2: resd 10000        ; Second input matrix
    matrix3: resd 10000        ; Transpose of first matrix
    matrix4: resd 10000        ; Storage for result matrix

section .text
main:
    push rbp
    mov rbp, rsp
    sub rsp, 32

    ; Read dimensions n, m, p from input
    lea rsi, [n]
    call RI

    lea rsi, [m]
    call RI

    ; Check matrix sizes
    mov edi, DWORD [n]
    mov esi, DWORD [m]
    mov edx, DWORD [max]
    call CMS
    cmp rax, 1
    je size_error

    ; Read elements
    mov edi, DWORD [n]
    mov esi, DWORD [m]
    lea rdx, [matrix1]
    call RIM

    mov edi, DWORD [n]
    mov esi, DWORD [m]
    lea rdx, [matrix2]
    call RIM

    ; Transpose matrix1 and store in matrix3
    mov edi, DWORD [n]
    mov esi, DWORD [m]
    lea rdx, [matrix1]
    lea rcx, [matrix3]
    call TIM

    ; Multiply matrix3 and matrix2 and store in matrix4
    mov edi, DWORD [m]      ; First matrix rows (m)
    mov esi, DWORD [n]      ; First matrix cols (n)
    mov edx, DWORD [m]      ; Second matrix cols (m)
    lea rcx, [matrix3]      ; First matrix (A^T)
    lea r8, [matrix2]       ; Second matrix (B)
    lea r9, [matrix4]       ; Result matrix (C)
    call MIM

    ; Calculate trace of the resulting matrix
    mov edi, DWORD [m]
    lea rsi, [matrix4]
    call TIMC

    ; Print the trace of the matrix
    mov rsi, rax              ; Set trace value as argument
    call PI
    call PN

    mov rax, 0
    add rsp, 32
    leave
    ret

; Error handler for matrix size exceeded
size_error:
    mov rax, 1
    add rsp, 32
    leave
    ret

section	.note.GNU-stack