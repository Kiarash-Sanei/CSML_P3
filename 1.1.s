global main
extern RI
extern CMS
extern RIM
extern MIM
extern PIM

section .data
    max: dd 10000                      ; Maximum allowed matrix size

section .bss
    n: resd 1                          ; Number of rows in first matrix
    m: resd 1                          ; Number of columns in first matrix/rows in second matrix
    p: resd 1                          ; Number of columns in second matrix
    matrix1: resd 10000                ; Storage for first matrix
    matrix2: resd 10000                ; Storage for second matrix
    matrix3: resd 10000                ; Storage for result matrix

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

    lea rsi, [p]
    call RI

    ; Check matrix sizes
    mov edi, DWORD [n]
    mov esi, DWORD [m]
    mov edx, DWORD [max]
    call CMS
    cmp rax, 1
    je size_error

    mov edi, DWORD [m]
    mov esi, DWORD [p]
    mov edx, DWORD [max]
    call CMS
    cmp rax, 1
    je size_error

    mov edi, DWORD [n]
    mov esi, DWORD [p]
    mov edx, DWORD [max]
    call CMS
    cmp rax, 1
    je size_error

    ; Read elements
    mov edi, DWORD [n]
    mov esi, DWORD [m]
    lea rdx, [matrix1]
    call RIM

    mov edi, DWORD [m]
    mov esi, DWORD [p]
    lea rdx, [matrix2]
    call RIM
    
    ; Multiply matrices
    mov edi, DWORD [n]
    mov esi, DWORD [m]
    mov edx, DWORD [p]
    lea rcx, [matrix1]
    lea r8, [matrix2]
    lea r9, [matrix3]
    call MIM

    ; Print resulting matrix
    mov edi, DWORD [n]
    mov esi, DWORD [p]
    lea rdx, [matrix3]
    call PIM

    mov eax, 0
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