[org 0x7c00]	
KERNEL_LOCATION equ 0x1000


mov [DISK], dl 


xor ax, ax
mov es, ax			; extra segment
mov ds, ax			; data segment
mov bp, 0x8000	; base pointer (base of the stack)
mov sp, bp			; stack pointer (top of the stack) 


mov bx, KERNEL_LOCATION
mov dh, 2

mov ah, 0x02		
mov al, dh			
mov ch, 0x00		
mov dh, 0x00		
mov cl, 0x02		
mov dl, [DISK]  
int 0x13				; read 20 sectors from disk 


mov ah, 0x0
mov al, 0x3
int 0x10				; switch to text mode


CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start

cli
lgdt [GDT_descriptor]
mov eax, cr0
or eax, 1
mov cr0, eax

jmp CODE_SEG:start_protected_mode

jmp $

DISK: db 0
GDT_Start:
	null_descriptor:
		dd 0
		dd 0
	code_descriptor:
		dw 0xffff
		dw 0x0	
		db 0x0
		db 0b10011010
		dw 0b11001111
		db 0x0
	data_descriptor:
		dw 0xffff
		dw 0x0
		db 0x0
		db 0b10010010
		db 0b11001111
		db 0x0
GDT_End:


GDT_descriptor:
	dw GDT_End - GDT_Start - 1;
	dd GDT_Start




[bits 32]
start_protected_mode:
	mov ax, DATA_SEG			; set up segmento registers and stack
	mov ds, ax
	mov ss, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ebp, 0x90000
	mov esp, ebp

	jmp KERNEL_LOCATION 

times 510-($-$$) db 0
dw 0xaa55

