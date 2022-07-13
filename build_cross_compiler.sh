#!/bin/bash

mkdir -p build_cross;
rm -rf build_cross/*;

nasm boot.asm -f bin -o build_cross/boot.bin;
nasm kernel_entry.asm -f elf -o build_cross/kernel_entry.o; # could be -f elf?
i386-elf-gcc -ffreestanding -m32 -g -c kernel.c -o build_cross/kernel.o; # could be -target x86?
nasm zeroes.asm -f bin -o build_cross/zeroes.bin;

i386-elf-ld -o build_cross/full_kernel.bin -Ttext 0x1000 build_cross/kernel_entry.o build_cross/kernel.o --oformat binary --entry main;

cat boot.bin full_kernel.bin zeroes.bin > build_cross/os.bin;
#qemu-system-x86_64 -drive format=raw,file="./os.bin",index=0,if=floppy,  -m 128M
