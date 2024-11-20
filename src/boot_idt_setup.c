#include <stdint.h>

#define IDT_MAX_VECTORS 256

typedef struct {
	uint16_t isr_0;
	uint16_t CS;
	uint8_t zero;
	uint8_t attributes;
	uint16_t isr_1;
}
__attribute__((packed)) interrupt_descriptor_t;

__attribute__((aligned(0x10)))
static interrupt_descriptor_t idt[IDT_MAX_VECTORS];

struct {
	uint16_t limit;
	uint32_t base;
} __attribute__((packed)) idtr;

extern void* isr_stub_table[];

extern void _lodidt(uint32_t idt);

extern void C_SETUP_IDT(){	
	// Generate IDTR
	idtr.base = (uintptr_t)&idt[0];
	idtr.limit = (uint16_t)sizeof(interrupt_descriptor_t) * (IDT_MAX_VECTORS - 1);
	
	for (uint8_t i = 0; i < 32; i++) { 
		idt[i].isr_0        = (uint32_t)isr_stub_table[i] & 0xFFFF;
        idt[i].CS      	    = 0x08;
        idt[i].attributes   = 0x8E;
        idt[i].isr_1	  	= (uint32_t)isr_stub_table[i] >> 16;
        idt[i].zero       	= 0;
	}
	
	// Load the IDT
	_lodidt((uint32_t)&idtr);
}

extern void C_EX_ERR(int errc){

}

extern void C_EX_NOERR(){

}