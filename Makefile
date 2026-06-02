ASM=nasm
QEMU=qemu-system-i386

all: build/boot.bin

build/boot.bin: boot/boot.asm
	$(ASM) -f bin boot/boot.asm -o build/boot.bin

run: all
	$(QEMU) -drive format=raw,file=build/boot.bin

clean:
	rm -f build/*.bin