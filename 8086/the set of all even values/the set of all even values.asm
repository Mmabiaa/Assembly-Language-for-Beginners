org 100h

.data
data db 34,81,23,26,4,13,7,6,24,71
count equ $-data
msgA db 'Elements:',13,10,'$'
msgB db 'Even values:',13,10,'$'

.code
start:
    ; Print all elements
    mov dx, offset msgA
    call PRINT_STR
    mov si, offset data
    mov cx, count
p_all:
    mov al, [si]
    call PRINT_BYTE
    call PRINT_NL
    inc si
    loop p_all

    ; Print set of even values
    mov dx, offset msgB
    call PRINT_STR
    mov si, offset data
    mov cx, count
p_even:
    mov al, [si]
    test al, 1
    jnz not_even
    call PRINT_BYTE
    call PRINT_NL
not_even:
    inc si
    loop p_even

    mov ax, 4C00h
    int 21h

; --- utilities (same as Program 1) ---
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
    cmp ax, 0
    jne pn2_div
    mov dl, '0'
    mov ah, 02h
    int 21h
    jmp pn2_done
pn2_div:
pn2_loop:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne pn2_loop
pn2_print:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop pn2_print
pn2_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PRINT_NUM endp

PRINT_STR proc
    mov ah, 09h
    int 21h
    ret
PRINT_STR endp

PRINT_NL proc
    mov ah, 02h
    mov dl, 0Dh
    int 21h
    mov dl, 0Ah
    int 21h
    ret
PRINT_NL endp
