ORG 0x7c00
BITS 16

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start

_start:
	jmp short start ;BPB (bios parameter block) so we are safe if booting from pendrive
	nop
	times 33 db 0

start:
	jmp 0x0:step2 ; this effectively sets the CS to 0x7c0

step2:
	cli
	mov ax, 0x00
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7c00
	sti


.load_protected:
	cli
	lgdt [gdt_descriptor]
	mov eax, cr0
	or eax, 0x1
	mov cr0, eax
	jmp CODE_SEG:load32


gdt_start:

gdt_null:
	dd 0x0
	dd 0x0


gdt_code:			; code segment will point to this
	dw 0xffff		; segment limit first 15 bits 
	dw 0x0			; base first 15 bits
	db 0x0			; base 16~23 bits
	db 0x9a			; access bytes
	db 0b11001111
	db 0x0

gdt_data:			; DS, SS, ES, FS, GS
	dw 0xffff		; segment limit first 15 bits 
	dw 0x0			; base first 15 bits
	db 0x0			; base 16~23 bits
	db 0x92			; access bytes
	db 0b11001111
	db 0x0
gdt_end:

gdt_descriptor:
	dw gdt_end - gdt_start - 1
	dd gdt_start


[BITS 32]
load32:
	mov eax, 1
	mov ecx, 100
	mov edi, 0x0100000
	call ata_lba_read
	jmp CODE_SEG:0x0100000

ata_lba_read:
	mov ebx, eax
	; send the highest 8 bits of the lba to hard disk controller
	shr eax, 24
	or eax, 0xE0 ; select master drive
	mov dx, 0x1F6
	out dx, al
	;; finished sending highest 8 bits of lba

	; send total sectors to read
	mov eax, ecx
	mov dx, 0x1F2
  out dx, al	

	; send more bits of the lba
	mov eax, ebx
	mov dx, 0x1F3
	out dx, al

	
	; send more bits of the lba
	mov dx, 0x1F4
	mov eax, ebx
	shr eax, 8
	out dx, al


	;send upper 16 bits of the lba
	mov dx, 0x01F5
	mov eax, ebx
	shr eax, 16
	out dx, al
	

	mov dx, 0x1F7
	mov al, 0x20
	out dx, al

	;read all sectors into memory

.next_sector:
	push ecx

; checking if we need to read more
.try_again:
	mov dx, 0x1F7
	in al, dx
	test al, 8
	jz .try_again


	; we nedd to read 256 words at a time
	mov ecx, 256 ; amount of words to read (word = 2bytes) so 256 words = 512 bytes (1 sector)
	mov dx, 0x1F0
	rep insw ; read from serial port to buffer at edi (which we already set to 0x0100000)

	pop ecx
	loop .next_sector
	ret

times 510 - ($ - $$) db 0
	;read all sectors into memory
dw 0xaa55
