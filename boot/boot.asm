[org 0x7c00]
[bits 16]

start:
    mov si, message
    call print_string

hang:
    cli
    hlt
    jmp hang

print_string:
    mov ah, 0x0e

.print_loop:
    lodsb
    cmp al, 0
    je .done
    int 0x10
    jmp .print_loop

.done:
    ret

message:
    db "Booting AymanOS...", 0

times 510 - ($ - $$) db 0
dw 0xaa55