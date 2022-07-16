ak_print_s:
	mov ah, 0x0e

	loop:
		lodsb
		or al, al
		jz end
		mov ah, 0x0e
		int 10h
		jmp loop
		

	end:
		ret
