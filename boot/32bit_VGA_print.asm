[bits 32]

VIDEO_MEMORY equ 0xb8000 - DATA_LOW_BASE
WHITE_ON_BLACK equ 0x000f

print_string_32:
	pusha
	mov edx, VIDEO_MEMORY
	sub ebx, DATA_LOW_BASE
print_string_32_loop:
	mov al, [ebx]
	cmp al, 0x0
	je print_done_32
	mov ah, WHITE_ON_BLACK
	mov [edx], ax
	
	add ebx, 1
	add edx, 2
	jmp print_string_32_loop

print_done_32:
	popa
	ret
