[org 0x7c00]	;BIOS loads MBR into memory address 0x7c00 (2 sectors offset?) so every thing must be offset by this number.

KERNEL_LOCATION equ 0x1000
DISK: db 0

mov [DISK], dl ; after booting, the disk that containted the booter is in dl

xor ax, ax
mov es, ax			; extra segment
mov ds, ax			; data segment
mov bp, 0x8000	; base pointer (base of the stack)
mov sp, bp			; stack pointer (top of the stack) 


mov bx, KERNEL_LOCATION
mov dh, 20
mov ah, 0x02		; read sectors
mov al, dh			; number of sectors to read
mov ch, 0x00		; track/cylinder number
mov dh, 0x00		; head number
mov cl, 0x02		; sector number (the boot sector is the first sector)
mov dl, [DISK]  ; drive number
int 0x13				; read 20 sectors from disk 

mov ah, 0x0
mov al, 0x3
int 0x10				; switch to text mode


; start GLOBAL DESCRIPTOR TABLE WORK
CODE_SEG equ code_descriptor - GDT_Start
DATA_SEG equ data_descriptor - GDT_Start

cli
lgdt [GDT_Descriptor]

; switch to 32bit 
mov eax, cr0
or eax, 1
mov cr0, eax

; far jump (jmping to other segment)
jmp CODE_SEG:start_protected_mode

jmp $

GDT_Start:
	null_descriptor:
		dd 0
		dd 0
	code_descriptor:
		dw 0xffff			; (first 16bit of limit) (maximum addressable unit 20bit value if using page granularity, the segment will spawnn 0XFFFFF * 4KiB (4GiB) address space in 32bit mode)
		dw 0					;
		db 0					; 24 first bits of base
		db 0b10011010 ; Access Byte
									; 1bit (1 present 0 not used) 2bit (privilege, highest is 00) 1bit (type 1 for code 0 for data) (p, p, t)
									; 1bit (code segment? 1 : 0) 1bit (conforming can be exec by lower privliges ? 0 : 1) 1bit (readable ? 1 : 0) 1bit (accessed 0 let cpu handle) type flags)
		dw 0b11001111	; Other Flags
									; 1bit (page granularity 1 => limit *= 0x1000 (4GBmem) addressable unit either 1byte or 4KiB pages) 1bit (32 bit memory ? 1 : 0) (other flags) 2bits (00, AVL)
									; 4bit 1111 (last four bits of limit)
		db 0					; last 8 bits of the base
	data_descriptor:
		dw 0xffff
		dw 0
		db 0
		db 0b10010010
		db 0b11001111
		db 0
GDT_End:


GDT_Descriptor:
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

