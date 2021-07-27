.PHONY: main compile link run clean

main: compile run

compile: bootloader.asm
	nasm -f bin bootloader.asm -o bootloader.bin

run: bootloader.bin
	qemu-system-x86_64 bootloader.bin