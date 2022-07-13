#!/bin/bash


clang -ffreestanding -m32 -g -c kernel.c -o kernel.o; # could be -target x86?
nasm kernel_entry.asm -f elf -o kernel_entry.o; # could be -f elf?
ld -o full_kernel.bin -m elf_i386 -Ttext 0x1000 kernel_entry.o kernel.o --oformat binary --entry main;
nasm -f bin boot.asm -o boot.bin;
cat boot.bin full_kernel.bin > os.bin;


#qemu-system-x86_64 -drive format=raw,file="./os.bin",index=0,if=floppy,  -m 128M
