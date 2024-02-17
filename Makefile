ARCH=i386-elf-
AS=nasm
ASFLAGS=-f bin
CC=$(ARCH)gcc
LD=$(ARCH)ld
CFLAGS=-m32 -g -ffreestanding -c
LDFLAGS=-m elf_i386 -Ttext 0x1000
LDFLAGS_BIN=--oformat binary
GDB=$(ARCH)gdb

# Target OS image
OS_IMAGE=./bin/os-image.bin

# Boot sector source and binary
BOOT_SECT_PATH=./boot
BOOT_SECT_SRC=$(BOOT_SECT_PATH)/boot_sect_main.asm
BOOT_SECT_BIN=$(BOOT_SECT_SRC:.asm=.bin)

# Kernel sources and binaries
KERNEL_PATH=./kernel
KERNEL_SRC=$(KERNEL_PATH)/kernel.c
KERNEL_OBJ=$(KERNEL_SRC:.c=.o)
KERNEL_BIN=$(KERNEL_PATH)/kernel.bin
KERNEL_ELF=$(KERNEL_PATH)/kernel.elf

# Default target
all: $(OS_IMAGE)

$(OS_IMAGE): $(BOOT_SECT_BIN) $(KERNEL_BIN)
	cat $^ > $@

$(BOOT_SECT_BIN): $(BOOT_SECT_SRC)
	$(AS) $(ASFLAGS) $< -o $@

$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) $(LDFLAGS_BIN) -o $@ $<

$(KERNEL_OBJ): $(KERNEL_SRC)
	$(CC) $(CFLAGS) -o $@ $<

$(KERNEL_ELF): $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o $@ $<

debug: $(OS_IMAGE) $(KERNEL_ELF)
	qemu-system-i386 -S -s -drive format=raw,file=$(OS_IMAGE) &
	$(GDB) -ex "target remote localhost:1234" -ex "symbol-file $(KERNEL_ELF)"

run:
	qemu-system-x86_64 -drive format=raw,file=$(OS_IMAGE)

# Clean build files
clean:
	rm -f $(BOOT_SECT_BIN) $(OS_IMAGE) $(KERNEL_BIN) $(KERNEL_ELF) $(KERNEL_OBJ)

.PHONY: all clean debug run
