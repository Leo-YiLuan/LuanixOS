[org 0x7c00]
KERNEL_MEMORY equ 0x1000
VGA_MEMORY equ 0xb8000
mov bp, 0x9000

mov sp, bp

mov ah, 0x02
mov al, 0x04	; load more sectors with 0x0 make jc jump, however, it is still working fine and status ah is 0x0.
push ax	; save dl to stack, num of sectors intened to read
mov ch, 0x00
mov cl, 0x02
mov dh, 0x0
mov dl, 0x80
mov bx, KERNEL_MEMORY
int 0x13

;jc disk_error

;pop dx
;cmp al, dl	; al is the actual number of read sectors, compare
;jne sector_error

mov bx, DISK_SUCCESS_MSG
jmp print_loop_success




disk_error:
	mov bx, DISK_ERROR_MSG
	jmp print_loop_error
sector_error:
	mov bx, SECT_ERROR_MSG
	jmp print_loop_error
print_loop_error:
	mov al, [bx] 
	cmp al, 0
	je done_error
	
	mov ah, 0x0e
	int 0x10

	add bx, 0x01
	jmp print_loop_error

done_error:
	jmp $

print_loop_success:
	mov al, [bx] 
	cmp al, 0
	je done_success
	
	mov ah, 0x0e
	int 0x10

	add bx, 0x01
	jmp print_loop_success

done_success:
	jmp switch_to_pm
	;jmp $

[bits 16]
switch_to_pm:
	cli
	lgdt [GDT_descriptor]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:start_pm
[bits 32]
start_pm:
	mov dx, DATA_SEG
	mov ds, dx
	 
	jmp start_kernel
start_kernel:
	mov ax, 0x0f00
	mov [VGA_MEMORY], ax
	call KERNEL_MEMORY
	jmp $



GDT_start:
GDT_null:
	dd 0x0
	dd 0x0
GDT_code:
	dw 0xFFFF
	dw 0x00
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
GDT_data:
	dw 0xFFFF
	dw 0x00
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
GDT_end:

GDT_descriptor:
	dw GDT_end - GDT_start - 1
	dd GDT_start

CODE_SEG equ GDT_code - GDT_start
DATA_SEG equ GDT_data - GDT_start
DISK_ERROR_MSG: db "Disk Error.", 0x0
SECT_ERROR_MSG: db "Sector Error.", 0x0
DISK_SUCCESS_MSG: db "Disk Load Succeed.", 0x0
times 510-($-$$) db 0
dw 0xaa55
