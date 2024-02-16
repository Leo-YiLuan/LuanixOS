AS=nasm
ASFLAGS=-f bin

# Target OS image
OS_IMAGE=os-image.bin

# Boot sector source and binary
BOOT_SECT_SRC=boot_sect_main.asm
BOOT_SECT_BIN=$(BOOT_SECT_SRC:.asm=.bin)

# Kernel binary
KERNEL_BIN=kernel.bin

# Default target
all: $(OS_IMAGE)

$(OS_IMAGE): $(BOOT_SECT_BIN) $(KERNEL_BIN)
	cat $(BOOT_SECT_BIN) $(KERNEL_BIN) > $(OS_IMAGE)

$(BOOT_SECT_BIN): $(BOOT_SECT_SRC)
	$(AS) $(ASFLAGS) $< -o $@

# Clean build files
clean:
	rm -f $(BOOT_SECT_BIN) $(OS_IMAGE)

.PHONY: all clean

