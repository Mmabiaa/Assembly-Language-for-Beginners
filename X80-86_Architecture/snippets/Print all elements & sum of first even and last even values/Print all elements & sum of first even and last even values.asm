org 100h

.data
data    db 34,81,23,26,4,13,7,6,24,71
count   equ $-data
msgA    db 'Elements:',13,10,'$'
msgB    db 'Sum of first and last even values:',13,10,'$'

first_even db 0
last_even  db 0

.code
start:
    ; ----------------------
    ; Print all elements
    ; ----------------------
    mov dx, offset msgA
    mov ah, 09h
    int 21h

    mov si, offset data
    mov cx, count
print_all:
    mov al, [si]
    call PRINT_BYTE
    call PRINT_NL
    inc si
    loop print_all

    ; ----------------------
    ; Find first & last even
    ; ----------------------
    mov si, offset data
    mov cx, count
    mov byte ptr [first_even], 0
    mov byte ptr [last_even], 0

find_loop:
    mov al, [si]
    test al, 1
    jnz next_item             ; skip odd

    cmp byte ptr [first_even], 0
    jne have_first
    mov [first_even], al      ; store first even
have_first:
    mov [last_even], al       ; always update last even
next_item:
    inc si
    loop find_loop

    ; ----------------------
    ; sum = first_even + last_even
    ; ----------------------
    mov al, [first_even]      ; load value (8-bit)
    mov ah, 0                 ; zero extend into AX
    mov bl, [last_even]       ; load value (8-bit)
    mov bh, 0                 ; zero extend into BX
    add ax, bx                ; AX = sum

    ; ----------------------
    ; Print result
    ; ----------------------
    mov dx, offset msgB
    mov ah, 09h
    int 21h
    call PRINT_NUM
    call PRINT_NL

    ; Exit
    mov ax, 4C00h
    int 21h

; ======================
; Utilities
; ======================

PRINT_BYTE proc
    xor ah, ah
    call PRINT_NUM
    ret
PRINT_BYTE endp

PRINT_NUM proc
    push ax
    push bx
    push cx
    push dx

    mov bx, 10
    xor cx, cx

next_div:
    xor dx, dx
    div bx
    push dx
    inc cx
    test ax, ax
    jnz next_div

print_loop:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop print_loop

    pop dx
    pop cx
    pop bx
    pop ax
    ret
PRINT_NUM endp

PRINT_NL proc
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    ret
PRINT_NL endp
