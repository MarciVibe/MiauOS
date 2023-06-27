ENTRY(start)

/* Define the different sections of the final executable file */
SECTIONS {
    /* Set the starting address of the program to 1M */
    . = 1M;

    /* .boot section contains the multiboot header */
    .boot :
    {
        /* ensure that the multiboot header is at the beginning */
        *(.multiboot_header)
    }

    /* .text section contains the code of the program */
    .text :
    {
        *(.text)
    }
}