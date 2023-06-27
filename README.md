# MiauOS

MiauOS is a 64-bit monolithic kernel built for x86_64 architecture. It is written in Rust and NASM, and is designed to be a lightweight and efficient operating system.

## Getting Started

### Prerequisites

To build and run MiauOS, you will need the following dependencies:

- QEMU
- Rust
- NASM
- Make
- binutils
- ld
- grub-mkrescue
- xorriso
- grub-pc-bin
- xargo

### Building and Running

To build and run MiauOS, follow these steps:

1. Clone the repository:
```
git clone https://github.com/MarciVibe/MiauOS.git
```

2. Change into the project directory:
```
cd MiauOS
```

3. Build the operating system:
```
make run
```

This will compile the operating system and launch it in QEMU.

## Features

MiauOS is a work in progress, but currently includes the following features:

- Boots
- Prints "Hello World!" to the middle of the screen with a blue background behind the text

## Acknowledgements

This project is based on the [Writing an OS in Rust (First Edition)](https://os.phil-opp.com/edition-1/) by Philipp Oppermann. I would like to thank Philipp for his excellent work and for providing a great starting point for this project.

## Contributing

Contributions to MiauOS are welcome! If you would like to contribute, please open an issue or pull request on the GitHub repository.

## License

MiauOS is licensed under the GNU GENERAL PUBLIC LICENSE (Version 3, 29 June 2007). See [LICENSE](LICENSE) for more information.