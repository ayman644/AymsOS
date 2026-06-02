[org 0x7c00]

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

[bits 16]

start:
    xor ax, ax
    mov ds, ax
    mov es, ax

    cli

    lgdt [gdt_descriptor]

    mov eax, cr0
    or eax, 1
    mov cr0, eax

    jmp CODE_SEG:init_protected_mode

; GDT
gdt_start:

gdt_null:
    dq 0x0000000000000000

gdt_code:
    ; Base = 0x00000000
    ; Limit = 0xFFFFF
    ; Code segment
    ; Granularity = 4KB
    ; 32-bit segment
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10011010b
    db 11001111b
    db 0x00

gdt_data:
    ; Base = 0x00000000
    ; Limit = 0xFFFFF
    ; Data segment
    ; Granularity = 4KB
    ; 32-bit segment
    dw 0xffff
    dw 0x0000
    db 0x00
    db 10010010b
    db 11001111b
    db 0x00

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

; 32-bit protected mode code

[bits 32]

init_protected_mode:
    mov ax, DATA_SEG
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    mov esp, 0x90000

    mov edi, 0xb8000
    mov ecx, 80 * 25

clear_screen:
    mov word [edi], 0x0f20
    add edi, 2
    loop clear_screen

    mov esi, protected_message
    mov edi, 0xb8000

print_pm_loop:
    lodsb
    cmp al, 0
    je protected_hang

    mov ah, 0x0f
    mov [edi], ax

    add edi, 2
    jmp print_pm_loop

protected_hang:
    cli
    hlt
    jmp protected_hang


protected_message:
    db "AymanOS entered 32-bit protected mode", 0


times 510 - ($ - $$) db 0
dw 0xaa55