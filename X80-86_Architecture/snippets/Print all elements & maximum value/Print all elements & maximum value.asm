org 100h

.data
data db 34,81,23,26,4,13,7,6,24,71
count equ $-data
msgA db 'Elements:',13,10,'$'
msgB db 'Maximum value:',13,10,'$'
buffer db 6 dup(?)      ; buffer for fast decimal printing
maxval dw 0

.code
start:
    ; ----------------------
    ; Print all elements
    ; ----------------------
    mov dx, offset msgA
    call PRINT_STR
    mov si, offset data
    mov cx, count
l1:
    mov al, [si]
    call PRINT_BYTE
    call PRINT_NL
    inc si
    loop l1

    ; ----------------------
    ; Find maximum value
    ; ----------------------
    mov si, offset data
    mov cx, count
    mov al, [si]        ; first element
    cbw
    mov maxval, ax
    inc si
    dec cx

l2:
    mov al, [si]
    cbw
    cmp ax, maxval
    jle skip_update
    mov maxval, ax
skip_update:
    inc si
    loop l2

    ; ----------------------
    ; Print result
    ; ----------------------
    mov dx, offset msgB
    call PRINT_STR
    mov ax, maxval
    call PRINT_NUM
    call PRINT_NL

    ; Exit
    mov ax, 4C00h
    int 21h

; ======================
; Utils
; ======================

; Print unsigned byte in AL
PRINT_BYTE proc
    mov ah, 0
    call PRINT_NUM
    ret
PRINT_BYTE endp

; Fast Print decimal AX using buffer
PRINT_NUM proc
    push ax
    push bx
    push cx
    push dx
    push si

    mov si, offset buffer
    mov bx, 10
    xor cx, cx

    cmp ax, 0
    jne pn_loop
    mov byte ptr [si], '0'
    inc cx
    jmp pn_done

pn_loop:
    xor dx, dx
    div bx              ; AX ÷ 10
    add dl, '0'
    mov [si], dl
    inc si
    inc cx
    cmp ax, 0
    jne pn_loop

pn_done:
    mov si, offset buffer
    add si, cx
    dec si
print_digits:
    mov dl, [si]
    mov ah, 02h
    int 21h
    dec si
    loop print_digits

    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PRINT_NUM endp

PRINT_STR proc
    mov ah,09h
    int 21h
    ret
PRINT_STR endp

PRINT_NL proc
    mov ah,02h
    mov dl,0Dh
    int 21h
    mov dl,0Ah
    int 21h
    ret
PRINT_NL endp
