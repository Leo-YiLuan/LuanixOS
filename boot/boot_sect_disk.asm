disk_load:
	; input param: 
	; 	dh: Number of sectors will be read
	;	es: Memory section
	;	bx: Memory offset
	pusha

	mov ah, 0x02
	mov al, dh	; dh is the sector number will be read
	mov ch, 0x0	; cylinder
	mov cl, 0x02	; sector number
	push dx 
	mov dh, 0x0		; head number
	mov dl, 0x80 ;boot driver set by default
	int 0x13

	jc disk_error
	cmp ah, 0x00	; return code 0x0 means success
	jne disk_error
	
	pop dx
	cmp al, dh
	jne sector_error
	
	popa
	ret

disk_error:
	; print error message
	mov bx, DISK_ERROR_MESSAGE
	push ax
	call print_string
						;print error code
	xor dx, dx
	pop ax
	call print_hex
	call print_nl
	jmp $

sector_error:
	mov bx, SECTOR_ERROR_MESSAGE
	call print_string
	jmp $

DISK_ERROR_MESSAGE: db "Disk error: ", 0x0
SECTOR_ERROR_MESSAGE: db "Sector error", 0x0
