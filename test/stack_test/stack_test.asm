;[org 0x7c00]

mov bp, 0x9000
mov	sp, bp
mov bx, 0x7c0
mov ds, bx
mov bx, TEST
;push bx
;xor bx, bx
;mov bx, [0x8FFE]
call print_string
;mov al, [bx]
;mov ah, 0x0e
;int 0x10

jmp $
%include "../boot_sect_print.asm"

TEST: db "ABCDEFG1234567", 0x0
TESTC: db "X"
times 510-($-$$) db 0
dw 0xaa55
