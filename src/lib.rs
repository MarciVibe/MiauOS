#![feature(lang_items)]
#![no_std]

#[no_mangle]
pub extern "C" fn rust_main() {}

#[lang = "eh_personality"]
#[no_mangle]
pub extern "C" fn eh_personality() {}

#[panic_handler]
fn _panic(_info: &core::panic::PanicInfo) -> ! {
    loop {}
}
