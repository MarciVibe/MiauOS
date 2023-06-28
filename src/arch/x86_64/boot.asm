global start
extern long_mode_start

section .text
bits 32

; Entry point of the program
start:
    ; Set up the stack pointer
    mov esp, stack_top

    ; Check if the system supports multiboot
    call check_multiboot

    ; Check if the CPU supports CPUID
    call check_cpuid

    ; Check if the CPU supports long mode
    call check_long_mode

    ; Set up the page tables
    call set_up_page_tables

    ; Enable paging
    call enable_paging

    ; Load the GDT
    lgdt [gdt64.pointer]

    ; Jump to the long mode start address
    jmp gdt64.code:long_mode_start
    
    ; If any of the checks fail, jump to this function to print an error message
    error:
        mov dword [0xb8000], 0x4f524f45 ; "ERR:"
        mov dword [0xb8004], 0x4f3a4f52 ; ":OR"
        mov dword [0xb8008], 0x4f204f20 ; " O "
        mov byte  [0xb800a], al         ; Print the error code
        hlt

; Checks if the system supports multiboot. If not, jumps to the error function.
check_multiboot:
    cmp eax, 0x36d76289 ; Check if the magic number is correct
    jne .no_multiboot   ; If not, jump to the error function
    ret
.no_multiboot:
    mov al, "0"         ; Set the error code to 0
    jmp error

; Checks if the CPU supports CPUID. If not, jumps to the error function.
check_cpuid:
    ; Check if CPUID is supported by attempting to flip the ID bit (bit 21)
    ; in the FLAGS register. If we can flip it, CPUID is available.

    ; Copy FLAGS in to EAX via stack
    pushfd
    pop eax

    ; Copy to ECX as well for comparing later on
    mov ecx, eax

    ; Flip the ID bit
    xor eax, 1 << 21

    ; Copy EAX to FLAGS via the stack
    push eax
    popfd

    ; Copy FLAGS back to EAX (with the flipped bit if CPUID is supported)
    pushfd
    pop eax

    ; Restore FLAGS from the old version stored in ECX (i.e. flipping the
    ; ID bit back if it was ever flipped).
    push ecx
    popfd

    ; Compare EAX and ECX. If they are equal then that means the bit
    ; wasn't flipped, and CPUID isn't supported.
    cmp eax, ecx
    je .no_cpuid        ; If CPUID isn't supported, jump to the error function
    ret
.no_cpuid:
    mov al, "1"         ; Set the error code to 1
    jmp error

; Checks if the CPU supports long mode. If not, jumps to the error function.
check_long_mode:
    ; Test if extended processor info is available
    mov eax, 0x80000000 ; Implicit argument for CPUID
    cpuid               ; Get highest supported argument
    cmp eax, 0x80000001 ; It needs to be at least 0x80000001
    jb .no_long_mode    ; If it's less, the CPU is too old for long mode

    ; Use extended info to test if long mode is available
    mov eax, 0x80000001 ; Argument for extended processor info
    cpuid               ; Returns various feature bits in ECX and EDX
    test edx, 1 << 29   ; Test if the LM-bit is set in the D-register
    jz .no_long_mode    ; If it's not set, there is no long mode
    ret
.no_long_mode:
    mov al, "2"         ; Set the error code to 2
    jmp error

; Sets up the page tables
set_up_page_tables:
    ; Map first P4 entry to P3 table
    mov eax, p3_table
    or eax, 0b11 ; Present + writable
    mov [p4_table], eax

    ; Map first P3 entry to P2 table
    mov eax, p2_table
    or eax, 0b11 ; Present + writable
    mov [p3_table], eax

    ; Map each P2 entry to a 2MiB page
    mov ecx, 0 ; Counter variable

.map_p2_table:
    ; Map ecx-th P2 entry to a huge page that starts at address 2MiB*ecx
    mov eax, 0x200000 ; 2MiB
    mul ecx           ; Start address of ecx-th page
    or eax, 0b10000011 ; Present + writable + huge page
    mov [p2_table + ecx * 8], eax ; Map ecx-th entry

    inc ecx          ; Increase counter
    cmp ecx, 512     ; If counter == 512, the whole P2 table is mapped
    jne .map_p2_table ; Else map the next entry

    ret

; Enables paging
enable_paging:
    ; Load P4 to CR3 register (CPU uses this to access the P4 table)
    mov eax, p4_table
    mov cr3, eax

    ; Enable PAE-flag in CR4 (Physical Address Extension)
    mov eax, cr4
    or eax, 1 << 5
    mov cr4, eax

    ; Set the long mode bit in the EFER MSR (Model Specific Register)
    mov ecx, 0xC0000080
    rdmsr
    or eax, 1 << 8
    wrmsr

    ; Enable paging by setting the paging bit in CR0 register
    mov eax, cr0
    or eax, 1 << 31
    mov cr0, eax

    ret

section .rodata
gdt64:
    dq 0 ; Zero entry
.code: equ $ - gdt64 ; Calculate the offset of the code segment
    dq (1<<43) | (1<<44) | (1<<47) | (1<<53) ; Code segment
.pointer:
    dw $ - gdt64 - 1
    dq gdt64

section .bss
align 4096

; Page tables
p4_table:
    resb 4096
p3_table:
    resb 4096
p2_table:
    resb 4096

; Stack memory
stack_bottom:
    resb 64
stack_top: