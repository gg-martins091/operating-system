[org 0x7c00]	;BIOS loads MBR into memory address 0x7c00 so every thing must be offset by this number.
							; if we didnt do that, we would need something like this two lines below "mov al, [myString + 0x7c00]"

; call and ret 

mov ax, 0
int 0x16 ; wait for the input of a character

mov ah, 0x0e
int 0x10 ; print the given character

mov ah, 0x0e
mov bx, myString  

printString: ;print our string (learning)
	mov al, [bx] ; [] is a pointer, it is the points to the start of the string, same as C char *myString = "Hello World"
	cmp al, 0 ; if we reach the end of the string (null terminated) stop.
	je exit
	int 0x10 ; print current character in al
	inc bx ; increment the string pointer to get the next character
	jmp printString

exit:
	int 0x10

myString:
	db "Hello World", 0
; the boot sector is 512 bytes long ending in 0x55aa, so we fill it with padding zeros 
; $ means current code, $$ means beginning of current section, so jmp $ is an infinite loop, then all zeros until the 510th byte, then 0x55aa
; memory layout is always inverted so 0xaa55 = 0x55, 0xaa

jmp $ 
times 510-($-$$) db 0
dw 0xaa55



