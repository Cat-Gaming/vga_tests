; I know that this is bad coding but this is just a proof of concept
; - Tyleropher
[org 0x7c00]

mov ah, 0x00
mov al, 02h
int 0x10

mov si, COPYRIGHT_TEXT
call printf

mov si, STARTING_VGA_TEST
call printf

call wait_second
call wait_second
call wait_second
call wait_second
call wait_second
call wait_second
call wait_second
call wait_second
call wait_second
call wait_second

call vga_checkerboard
call vga_red
call vga_green
call vga_blue

mov si, VGA_TEST_COMPLETE
call printf

mov si, COPYRIGHT_TEXT
call printf

jmp $

vga_checkerboard:
    ; set video mode
    mov ax, 0x4f02
    mov bx, 0114h
    int 0x10

    mov cx, 0
    mov dx, 0

    mov al, 0x01 ; color
.loop:
    mov ah, 0x0C
    cmp dx, 600
    jg .test1
    inc dx
    int 0x10
    cmp al, 0x0F
    je .test2
    mov al, 0x0F
    jmp .loop
.test1:
    mov dx, 0
    cmp cx, 800
    je .end
    inc cx
    jmp .loop

.test2:
    mov al, 0x00
    jmp .loop

.end:
    mov ah, 0x00
    mov al, 02h
    int 0x10
    ret

vga_red:
    ; set video mode
    mov ax, 0x4f02
    mov bx, 0114h
    int 0x10

    mov cx, 0
    mov dx, 0

    mov al, 0x04 ; color
    jmp loop2
vga_blue:
    ; set video mode
    mov ax, 0x4f02
    mov bx, 0114h
    int 0x10

    mov cx, 0
    mov dx, 0

    mov al, 0x01 ; color
    jmp loop2
vga_green:
    ; set video mode
    mov ax, 0x4f02
    mov bx, 0114h
    int 0x10

    mov cx, 0
    mov dx, 0

    mov al, 0x02 ; color
    jmp loop2
loop2:
    mov ah, 0x0C
    cmp dx, 600
    jg test3
    inc dx
    int 0x10
    jmp loop2
test3:
    mov dx, 0
    cmp cx, 800
    je end2
    inc cx
    jmp loop2

end2:
    mov ah, 0x00
    mov al, 02h
    int 0x10
    ret

printf:
    mov ah, 0x0e
.loop:
    mov al, [si]
    cmp al, 0
    je .end
    int 0x10
    inc si
    jmp .loop
.end:
    ret

wait_second:
    mov cx, 0fh
    mov dx, 4240h
    mov ah, 86h
    int 15h
    ret

STARTING_VGA_TEST: db "Starting VGA Test in 10 seconds...", 0xd, 0xa, 0
VGA_TEST_COMPLETE: db "VGA Test Complete!", 0xd, 0xa, 0
COPYRIGHT_TEXT: db "Bootloader Copyright (C) 2021  Tyler Wendorff", 0xd, 0xa, "This program comes with ABSOLUTELY NO WARRANTY.", 0xd, 0xa, "This is free software, and you are welcome to redistribute it under certain conditions.", 0xd, 0xa, 0

times 510-($-$$) db 0
dw 0xaa55