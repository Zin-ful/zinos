org 0x7c00
bits 16


%define ENDL 0x0D, 0x0A

start:
    jmp main

; Prints a string to the screen
; Params:
;   - ds:si points to string

puts:
    ; save registers we will modify
    push si
    push ax

.loop:
    lodsb ; loads next char in al
    or al, al ; verify if next char is null
    jz .done
    
    mov ah, 0x0e
    int 0x10
    jmp .loop
    

.done:
    pop ax
    pop si
    ret

main:
    ; setup data segments
    mov ax, 0 ; cant write to ds/es directly
    mov ds, ax
    mov es, ax

    ; setup stack
    mov ss, ax
    mov sp, 0x7C00 ; stack grows downwards from here when loaded in mem
    ; printmsg
    mov si, msg_spam
    call puts
    call puts
    call puts
    hlt
    
.halt:
    jmp .halt

msg_hello: db 'WHATS UP GANG, ITS ME, YA BOI', ENDL, 0
msg_spam: db 'AYYOOO WHAT IT DO WHAT IT DO', ENDL, 0


times 510-($-$$) db 0
dw 0AA55h
