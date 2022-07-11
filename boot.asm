mov ah, 0x0e
mov al, 65 
int 0x10

loop:
	cmp al, 'Z'
	jge exit
	add al, 33
	int 0x10
	add al, -31
	int 0x10
	jmp loop

exit:
	jmp $

times 510-($-$$) db 0
db 0x55, 0xaa
