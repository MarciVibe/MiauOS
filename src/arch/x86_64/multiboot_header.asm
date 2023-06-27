section .multiboot_header
header_start:
    ; Magic number (multiboot 2)
    dd 0xe85250d6   

    ; Architecture 0 (protected mode i386)
    dd 0         

    ; Total header length
    dd header_end - header_start 

    ; Checksum
    dd 0x100000000 - (0xe85250d6 + 0 + (header_end - header_start))

    ; Optional multiboot tags go here

    ; Required end tag
    ; Type
    dw 0    
    ; Flags
    dw 0    
    ; Size
    dd 8    

header_end: 