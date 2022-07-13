#!/bin/bash


mkdir -p build;
rm -rf build/*;

nasm boot/boot.asm -f bin -o build/boot.bin;
nasm kernel/kernel_entry.asm -f elf -o build/kernel_entry.o; # could be -f elf?
clang -target i386-linux-pc-gnu -ffreestanding -m32 -g -c kernel/kernel.c -o build/kernel.o; # could be -target x86?
nasm kernel/zeroes.asm -f bin -o build/zeroes.bin;

ld -o build/full_kernel.bin -m elf_i386 -Ttext 0x1000 build/kernel_entry.o build/kernel.o --oformat binary --entry main;

cat build/boot.bin build/full_kernel.bin build/zeroes.bin > build/os.bin;

[ ! -z "$1" ] && qemu-system-x86_64 -drive format=raw,file="build/os.bin",index=0,if=floppy,  -m 128M
