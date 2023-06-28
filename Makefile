# Set the default architecture to x86_64
arch ?= x86_64

# Set the path to the kernel binary file
kernel := build/kernel-$(arch).bin

# Set the path to the ISO file
iso := build/os-$(arch).iso

# Set the path to the linker script
linker_script := src/arch/$(arch)/linker.ld

# Set the path to the GRUB configuration file
grub_cfg := src/arch/$(arch)/grub.cfg

# Find all assembly source files in the architecture directory
assembly_source_files := $(wildcard src/arch/$(arch)/*.asm)

# Compile all assembly source files to object files
assembly_object_files := $(patsubst src/arch/$(arch)/%.asm, \
	 build/arch/$(arch)/%.o, $(assembly_source_files))

# Set the target to the architecture and operating system name
target ?= $(arch)-MiauOS

# Set the path to the Rust object file
rust_os := target/$(target)/debug/libMiauOS.a

# Define the default targets
.PHONY: all clean run iso kernel

# Build the kernel binary file
all: $(kernel)

# Remove all build artifacts
clean:
	 rm -rf build target

# Run the operating system in QEMU
run: $(iso)
	 qemu-system-x86_64 -cdrom $(iso)

# Build the ISO file
iso: $(iso)

# Create the ISO file
$(iso): $(kernel) $(grub_cfg)
	 mkdir -p build/isofiles/boot/grub
	 cp $(kernel) build/isofiles/boot/kernel.bin
	 cp $(grub_cfg) build/isofiles/boot/grub
	 grub-mkrescue -o $(iso) build/isofiles 2> /dev/null
	 rm -r build/isofiles

# Build the kernel binary file
$(kernel): kernel $(rust_os) $(assembly_object_files) $(linker_script)
	 ld -n -T $(linker_script) -o $(kernel) \
			$(assembly_object_files) $(rust_os)

# Build the Rust object file
kernel:
	 RUST_TARGET_PATH=$(shell pwd) cargo build --target $(target)

# Compile assembly source files to object files
build/arch/$(arch)/%.o: src/arch/$(arch)/%.asm
	 mkdir -p $(shell dirname $ )
	 nasm -felf64 $< -o $ 
