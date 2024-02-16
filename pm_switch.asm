[org 0x7c00]                        
mov bp, 0x9000
mov sp,bp
mov bx, MSG_REAL_MODE
call print
mov bp, 0
mov sp, bp
jmp start_switch
%include "boot_sect_print.asm"

start_switch:
[bits 32]
call switch_pm
pm_begin:
	mov ebx, TESTMSG
	jmp print_string_32
    jmp $

%include "32bit_VGA_print.asm"
%include "gdt.asm"
%include "switch_pm.asm"
CHAR: db 'A'
TESTMSG: db "ABCDEFGHI", 0
MSG_REAL_MODE: db "16 bit real mode", 0
times 510-($-$$) db 0              
dw 0xaa55

