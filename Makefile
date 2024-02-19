ARCH=i386-elf-
AS=nasm
ASFLAGS=-f elf# Adjusted for compiling .asm to .o
CC=$(ARCH)gcc
LD=$(ARCH)ld
CFLAGS=-m32 -g -ffreestanding -c
LDFLAGS=-m elf_i386 -Ttext 0x1000
LDFLAGS_BIN=--oformat binary
GDB=$(ARCH)gdb


BOOT_SECT_PATH=./boot
KERNEL_PATH=./kernel
DRIVER_PATH=./driver

SRC_C=$(wildcard $(KERNEL_PATH)/*.c $(DRIVER_PATH)/*.c) 
OBJ=$(SRC_C:.c=.o)

HEADERS=$(wildcard $(KERNEL_PATH)/*.h $(DRIVER_PATH)/*.h)


# Kernel sources and binaries
KERNEL_SRC_ASM=$(wildcard $(KERNEL_PATH)/*.asm)  # All ASM source files in the kernel directory
KERNEL_OBJ_ASM=$(KERNEL_SRC_ASM:.asm=.o)

KERNEL_OBJ=$(KERNEL_OBJ_ASM) $(OBJ)
KERNEL_BIN=$(KERNEL_PATH)/kernel.bin
KERNEL_ELF=$(KERNEL_PATH)/kernel.elf

# Boot sector source and binary
BOOT_SECT_SRC=$(BOOT_SECT_PATH)/boot_sect_main.asm
BOOT_SECT_BIN=$(BOOT_SECT_SRC:.asm=.bin)

# Target OS image
OS_IMAGE=./bin/os-image.bin

# Default target
all: $(OS_IMAGE)

$(OS_IMAGE): $(BOOT_SECT_BIN) $(KERNEL_BIN)
	cat $^ > $@

$(BOOT_SECT_BIN): $(BOOT_SECT_SRC)
	$(AS) -f bin $< -o $@

$(KERNEL_BIN): $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) $(LDFLAGS_BIN) -o $@ $^

$(KERNEL_ELF): $(KERNEL_OBJ)
	$(LD) $(LDFLAGS) -o $@ $^

# Compiling C sources
%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -o $@ $<

# Compiling ASM sources
$(KERNEL_PATH)/%.o: $(KERNEL_PATH)/%.asm
	$(AS) $(ASFLAGS) -o $@ $<

debug: $(OS_IMAGE) $(KERNEL_ELF)
	qemu-system-i386 -S -s -drive format=raw,file=$(OS_IMAGE) &
	$(GDB) -ex "target remote localhost:1234" -ex "symbol-file $(KERNEL_ELF)"

run:
	qemu-system-x86_64 -drive format=raw,file=$(OS_IMAGE)

# Clean build files
clean:
	rm -f $(BOOT_SECT_BIN) $(OS_IMAGE) $(KERNEL_BIN) $(KERNEL_ELF) $(KERNEL_OBJ)

.PHONY: all clean debug run

