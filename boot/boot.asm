ORG 0
BITS 16
_start:
	jmp short start ;BPB (bios parameter block) so we are safe if booting from pendrive
	nop
	times 33 db 0

start:
	jmp 0x7c0:step2 ; this effectively sets the CS to 0x7c0

step2:
	cli
	mov ax, 0x7c0
	mov ds, ax
	mov es, ax
	mov ax, 0x00
	mov ss, ax
	mov sp, 0x7c00
	sti


	mov ah, 0x02 ; read sector interrupt call
	mov al, 0x01 ; read one sector
	mov ch, 0x0  ; cylinder
	mov cl, 0x02 ; read sector 0x02
	mov dh, 0x0  ; read from head 1
	mov bx, buffer
	int 0x13

	jc error

	mov si, buffer
	call print
	jmp $

error:
	mov si, error_message
	call print
	jmp $


print:
	mov bx, 0

.loop:
	lodsb
	cmp al, 0
	je .done
	call print_char
	jmp .loop

.done:
	ret

print_char:
	mov ah, 0x0e
	int 0x10
	ret


error_message: db 'Failed to load sector', 0

times 510 - ($ - $$) db 0
dw 0xaa55

buffer:
