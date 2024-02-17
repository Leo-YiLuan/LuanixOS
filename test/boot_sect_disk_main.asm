;mov bx, 0x7c0
;mov ds, bx]
[org 0x7c00]
mov bp, 0x8000
mov sp, bp

mov bx, 0x9000
mov dh, 2 	; Num of sectors to read
call disk_load

mov dx, [0x9000]
;mov dx, [0x9000-0x7c00]
call print_hex
mov dx, [0x9000 + 512]
;mov dx, [0x9000 + 512 - 0x7c00]
call print_hex
jmp $

%include "boot_sect_print_hex.asm"
%include "boot_sect_print.asm"
%include "boot_sect_disk.asm"

times 510-($-$$) db 0
dw 0xaa55

times 256 dw 0xdada
times 256 dw 0xface

