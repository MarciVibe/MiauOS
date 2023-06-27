arch ?= x86_64

# Define the output files
kernel := build/kernel-$(arch).bin
iso := build/os-$(arch).iso

# Define the linker script and GRUB configuration file
linker_script := src/arch/$(arch)/linker.ld
grub_cfg := src/arch/$(arch)/grub.cfg

# Define the directory paths
build_dir := build
src_dir := src
arch_dir := $(src_dir)/arch/$(arch)
build_arch_dir := $(build_dir)/arch/$(arch)
isofiles_dir := $(build_dir)/isofiles
boot_dir := $(isofiles_dir)/boot
grub_dir := $(boot_dir)/grub

# Define the Rust target
target ?= $(arch)-MiauOS

# Define the Rust library
rust_os := target/$(target)/debug/libMiauOS.a

# Define the default target
.PHONY: all clean run iso kernel
all: $(kernel)

# Define the clean target
clean:
	@rm -r $(build_dir)

# Define the run target
run: $(iso)
	@qemu-system-x86_64 -cdrom $(iso)

# Define the iso target
iso: $(iso)

# Create the ISO image
$(iso): $(kernel) $(grub_cfg)
	@mkdir -p $(grub_dir)
	@cp $(kernel) $(boot_dir)/kernel.bin
	@cp $(grub_cfg) $(grub_dir)
	@grub-mkrescue -o $(iso) $(isofiles_dir) 2> /dev/null
	@rm -r $(isofiles_dir)