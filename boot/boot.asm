ORG 0
BITS 16
_start:
	jmp short start ;BPB (bios parameter block) so we are safe if booting from pendrive
	nop
	times 33 db 0


start:
	jmp 0x7c0:step2 ; this effectively sets the CS to 0x7c0


handle_zero: ;int 0x0 handler
	mov ah, 0x0e
	mov al, 'Z'
	mov bx, 0x00
	int 0x10
	iret


step2:
	cli
	mov ax, 0x7c0
	mov ds, ax
	mov es, ax
	mov ax, 0x00
	mov ss, ax
	mov sp, 0x7c00
	sti

	;setting up our int 0x0 handler, set the first 2 bytes
	;of ram to our handler, and the next 2 bytes to the code segment 
	;that our handler is, so 0x7c0:handle_zero is our subroutine
	mov word [ss:0x00], handle_zero
	mov word [ss:0x02], 0x7c0


	mov si, message
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

message: db 'Hello World!', 0

times 510 - ($ - $$) db 0
dw 0xaa55
