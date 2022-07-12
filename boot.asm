[org 0x7c00]	;BIOS loads MBR into memory address 0x7c00 (2 sectors offset?) so every thing must be offset by this number.

mov [disk], dl ; get the drive number we just read from, after we boot the drive number is saved in dl

xor ax, ax                          
mov es, ax
mov ds, ax
mov bp, 0x8000
mov sp, bp


mov ax, 0
mov es, ax
mov ah, 2 ; disk read sectors interrupt call 13h
mov al, 1 ; number of sectors to read
mov ch, 0 ; the cylinder from which to read
mov cl, 2 ; the sector from which to read (the boot sector is 512 bytes and we alread read it, so the next sector (2) is the next 512 bytes)
mov dh, 0 ; head
mov dl, [disk] ; drive (disk number)
mov bx, 0x7e00 ; es:bs buffer address pointer is the extra segmento offset by 0x7e00 which is 0x7c00 + 512
int 0x13	; call disk service


mov ah, 0x0e
add al, 9776
int 0x10 

mov ah, 0x0e
mov al,[0x7e00]
int 0x10 ; check if it worked 

disk: db 0

jmp $ 
times 510-($-$$) db 0
dw 0xaa55

db 'A'
db 'B'
times 510 db 'J'


