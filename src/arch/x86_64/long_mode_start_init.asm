global long_mode_start

section .text
bits 64

; This function is the entry point of the program
long_mode_start:
    ; Set all data segment registers to 0
    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax

    ; Call the rust_main function, which is defined in a Rust module
    extern _start
    call _start

    ; Print the string "OKAY" to the screen
    ; The string is represented as a 64-bit value and stored at memory address 0xb8000
    mov rax, 0x2f592f412f4b2f4f ; ASCII representation of "OKAY"
    mov qword [0xb8000], rax
    hlt ; Halt the processor