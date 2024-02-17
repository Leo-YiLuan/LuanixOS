;[org 0x7c00] ; tell the assembler that our offset is bootsector code

; The main routine makes sure the parameters are ready and then calls the function

mov bx, 0x7c0
mov ds, bx
mov dx, 0x12fe
call print_hex

; that's it! we can hang now
jmp $

; remember to include subroutines below the hang
%include "boot_sect_print_hex.asm"
%include "boot_sect_print.asm"
%include "switch_pm.asm"
%include "gdt.asm"
; data

; padding and magic number
times 510-($-$$) db 0
dw 0xaa55
