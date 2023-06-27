// Enable certain features
#![feature(lang_items)]
// Don't link the standard library
#![no_std]

// Entry point of the program
#[no_mangle]
pub extern fn rust_main() {
    // ATTENTION: we have a very small stack and no guard page

    // Create a byte array containing the string "Hello World!"
    let hello_string = b"Hello World!";
    // Create a color byte representing white foreground and blue background
    let white_on_blue = 0x1f;

    // Create another byte array with the same length as the `hello_string` byte array,
    // and fill it with the `white_on_blue` color byte
    let mut hello_colored = [white_on_blue; 24];
    // Iterate over the `hello_string` byte array and copy each byte to the corresponding
    // position in the `hello_colored` byte array
    for (i, char_byte) in hello_string.into_iter().enumerate() {
        hello_colored[i*2] = *char_byte;
    }

    // Write `Hello World!` to the center of the VGA text buffer
    let vga_buffer_ptr = (0xb8000 + 1988) as *mut _;
    unsafe { *vga_buffer_ptr = hello_colored };
    
    // Loop forever
    loop {}
}

// Implementation of the `eh_personality` language item
#[lang = "eh_personality"]
#[no_mangle]
pub extern fn eh_personality() {}

// Panic handler for the program
#[panic_handler]
fn panic_handler(_info: &core::panic::PanicInfo) -> ! {
    // Loop forever
    loop {}
}