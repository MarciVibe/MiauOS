# MiauOS
A GH repo for an OS I am working on for the next 3 years, the OS will be a 64 bit monlothic kernel built for x86_64. As of now I will be using rust and nasm to build the OS though this is subject to change in the future.

## Building
make: all updated assembly files are complied and then linked
make iso: creates the iso image
make run: runs the iso image in qemu

## Dependencies
Qemu
Rust
Nasm
Make
binutils
ld
grub-mkrescue
xorriso
grub-pc-bin
## Current Features
Boots
Print ok to screen

## Honorable Mentions
https://os.phil-opp.com/multiboot-kernel/
^^ Has helped me get started with this massive project and I would like to thank the author for their work. And that this project is based off of their work.