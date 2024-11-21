#include <stdint.h>
#define SER_TX_PORT 0x03f8
#define SER_RD_PORT 0x03f8 + 5

static void dbg_serial_outch(char ch){
    __asm__ volatile ("outb %b0, %w1" : : "a"(ch), "Nd"(SER_TX_PORT) : "memory");
}
static void dbg_serial_txwait(){
    uint8_t ready = 0;
    while((ready&0x20) == 0){
        __asm__ volatile("inb %w1, %b0" : "=a"(ready) : "Nd"(SER_RD_PORT) : "memory");
        ready = ready & 0x20;
    }
}
extern void dbg_serial_println(char* str){
    for(int i = 0;; i++){
        if(str[i] == 0) break;
        dbg_serial_txwait();
        dbg_serial_outch(str[i]);
    }
    dbg_serial_outch(0x0a);
}