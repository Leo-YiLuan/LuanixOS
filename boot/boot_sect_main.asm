[org 0x7c00]
KERNEL_OFFSET equ 0x1000

;mov [BOOT_DRIVE], dl
mov bp, 0x9000
mov sp, bp

mov bx, MSG_REAL_MODE
call print_string
call print_nl
call load_kernel

call switch_pm

jmp $

%include "./boot/boot_sect_print_hex.asm"
%include "./boot/boot_sect_print.asm"
%include "./boot/boot_sect_disk.asm"
%include "./boot/switch_pm.asm"
%include "./boot/gdt.asm"
%include "./boot/32bit_VGA_print.asm"
[bits 16]

load_kernel:
	mov bx, MSG_LOAD_KERNEL
	call print_string
	mov bx, KERNEL_OFFSET
	mov dh, 2
	;mov dl, [BOOT_DRIVE]
	call disk_load
	ret

[bits 32]
;[extern main]
pm_begin:
	mov ebx, MSG_PROT_MODE
	call print_string_32
	call KERNEL_OFFSET
	;jmp $
	hlt	; The hlt instruction operates here because it is set to require privilege level 0,
		; as enforced in protected mode 

BOOT_DRIVE:	db 0
MSG_REAL_MODE:	db "Start 16 bits real mode", 0
MSG_PROT_MODE: 	db "Switched to 32 bits protected mode", 0
MSG_LOAD_KERNEL:	db "Start load kernel to memory", 0

	

times 510-($-$$) db 0
dw 0xaa55
