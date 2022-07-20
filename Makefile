all:
	nasm -f bin ./boot/boot.asm -o ./bin/boot.bin
	dd if=./message.txt >> ./bin/boot.bin
	dd if=/dev/zero bs=512 count=1 >> ./bin/boot.bin
