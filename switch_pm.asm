[bits 16]
switch_pm:
	cli
	lgdt [GDT_descriptor]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:start_protected_mode
[bits 32]
start_protected_mode:
	mov ax, DATA_SEG 
	mov ds, ax
	jmp pm_begin
