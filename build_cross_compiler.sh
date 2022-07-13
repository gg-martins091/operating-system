#!/bin/bash

mkdir -p build_cross;
rm -rf build_cross/*;

nasm boot/boot.asm -f bin -o build_cross/boot.bin;
nasm kernel/kernel_entry.asm -f elf -o build_cross/kernel_entry.o; # could be -f elf?
i386-elf-gcc -ffreestanding -m32 -g -c kernel/kernel.c -o build_cross/kernel.o; # could be -target x86?
nasm kernel/zeroes.asm -f bin -o build_cross/zeroes.bin;

i386-elf-ld -o build_cross/full_kernel.bin -Ttext 0x1000 build_cross/kernel_entry.o build_cross/kernel.o --oformat binary --entry main;

cat build_cross/boot.bin build_cross/full_kernel.bin build_cross/zeroes.bin > build_cross/os.bin;

[ ! -z "$1" ] && qemu-system-x86_64 -drive format=raw,file="build/os.bin",index=0,if=floppy,  -m 128M
