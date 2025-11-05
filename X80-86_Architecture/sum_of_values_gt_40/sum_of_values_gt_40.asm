org 100h

.data
data    db 34,81,23,26,4,13,7,6,24,71
count   equ $-data
msg1    db 'Elements:',13,10,'$'
msg2    db 'Sum of values > 40:',13,10,'$'

.code
start:
    mov dx, offset msg1
    call PRINT_STR

    ; Print all elements (each on its own line)
    mov si, offset data
    mov cx, count
print_all:
    mov al, [si]
    call PRINT_BYTE
    call PRINT_NL
    inc si
    loop print_all

    ; Sum of values > 40
    mov si, offset data
    mov cx, count
    xor ax, ax            ; AX = running sum (16-bit)
sum_gt40_loop:
    mov bl, [si]
    cmp bl, 40
    jle skip_add
    add ax, bx            ; add BL (zero-extended via BX)
skip_add:
    inc si
    loop sum_gt40_loop

    mov dx, offset msg2
    call PRINT_STR
    call PRINT_NUM
    call PRINT_NL

    mov ax, 4C00h
    int 21h

; --------- Utilities ----------
PRINT_BYTE proc
    xor ah, ah           ; zero-extend AL -> AX
    call PRINT_NUM
    ret
PRINT_BYTE endp

PRINT_NUM proc            ; AX = number to print (0..65535)
    push ax
    push bx
    push cx
    push dx

    mov bx, 10
    xor cx, cx
    cmp ax, 0
    jne pn_div
    ; print single '0'
    mov dl, '0'
    mov ah, 02h
    int 21h
    jmp pn_done

pn_div:
pn_div_loop:
    xor dx, dx
    div bx               ; AX = AX/10, DX = remainder
    push dx              ; save remainder
    inc cx
    cmp ax, 0
    jne pn_div_loop

pn_print:
    pop dx
    add dl, '0'
    mov ah, 02h
    int 21h
    loop pn_print

pn_done:
    pop dx
    pop cx
    pop bx
    pop ax
    ret
PRINT_NUM endp

PRINT_STR proc            ; DX -> $ string
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
