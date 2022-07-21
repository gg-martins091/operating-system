[BITS 32]
global _start
extern kernel_start

; this does not have a section .asm because it must go to .text section as it is the entry to our kernel
; it is already aligned with 512 bytes so it wouldn't misalign with c code
; if we did section .asm it would be put after everything else (see linker.ld the .asm section is the last one)
; only section .asm files will go there.

CODE_SEG equ 0x08
DATA_SEG equ 0x10

_start:
	mov ax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	mov ebp, 0x00200000
	mov esp, ebp

	; a20
	in al, 0x92
	or al, 0x2
	out 0x92, al

	call kernel_start
	jmp $

; fixed possible alignment issues with c compiled code
times 512 - ($ - $$) db 0
