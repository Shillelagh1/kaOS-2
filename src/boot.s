bits 32

; Defines
global max_isr
max_isr: equ 32

; Macros for exception/interrupt handling
%macro isr_err_stub 1
isr_stub_%+%1:
    xchg bx, bx
	pushad			; Preserve general purpose registers
	mov eax, [esp+32]	; Get the error code off the stack
	
	push eax
	push %1
    call C_EX_ERR
    pop eax
    pop eax			; Call Handler
    	
    popad
    pop eax
    iret			; Cleanup & Return
%endmacro
%macro isr_no_err_stub 1
isr_stub_%+%1:
    xchg bx, bx
	pushad			; Preserve general purpose registers

	push %1
    call C_EX_NOERR
    pop eax			; Call Handler

    popad
    iret
%endmacro
%macro b_out 2
    mov al, %2
    mov dx, %1
    out dx, al
%endmacro

; Multiboot header
MBALIGN  equ  1 << 0
MEMINFO  equ  1 << 1
MBFLAGS  equ  MBALIGN | MEMINFO
MAGIC    equ  0x1BADB002
CHECKSUM equ -(MAGIC + MBFLAGS)

section .multiboot
	align 4
		dd MAGIC
		dd MBFLAGS
		dd CHECKSUM

section .rodata
    ; Global Descriptor Table & it's register.
	pGDT:
		dd 0x00000000, 0x00000000 ; NULL
		dd 0x0000ffff, 0x00df9f00 ; EXEC 0
		dd 0x0000ffff, 0x00df9300 ; DATA 0
		pGDT_len: equ $ - pGDT
	pGDTR:
		dw (pGDT_len - 1)
		dq pGDT
    global isr_stub_table
    isr_stub_table:
        ; ISR Table
        %assign i 0 
        %rep max_isr
            dd isr_stub_%+i
            %assign i i+1 
        %endrep
    dbg_ser_entry_msg: db "===== KaOS2 Serial Log =====", 0

section .bss
    ; Create a temporary stack
	align 16
	stack_bottom:
	    resb 16384 ; 16 KiB
	    stack_top:

section .text
    ; Entry point for the kernel
    global _start
    _start:
        ; ========== Load the GDTR and long jump into the new segment.
        cli
        lgdt [pGDTR]
        jmp 0x08:.CS
    .CS:
        mov ax, 0x10
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax

        ; ========== Create the IDT and load the IDTR.
        extern C_SETUP_IDT
        call C_SETUP_IDT

        ; ========== Setup the PICs for our new interrupts.
        mov al, 0x11
        out 0x20, al
        out 0xA0, al	; Make PICs listen.
        
        mov al, 0x20
        out 0x21, al
        mov al, 0x28
        out 0xA1, al	; Set offset.
        
        mov al, 4
        out 0x21, al
        mov al, 2
        out 0xA1, al	; Configure for slavery.
        
        mov al, 1
        out 0xA1, al
        out 0x21, al	; Configure to 8086.
        
        mov al, 0xFF
        out 0x21, al
        out 0xA1, al

        ; ========== Setup debug serial port.
        ; Serial base addr 0x03f8.
        b_out 0x3f8 + 1, 0x00
        b_out 0x3f8 + 3, 0x80
        b_out 0x3f8 + 0, 0x03
        b_out 0x3f8 + 1, 0x00
        b_out 0x3f8 + 3, 0x03
        b_out 0x3f8 + 2, 0xc7
        b_out 0x3f8 + 4, 0x0b
        b_out 0x3f8 + 4, 0x1e
        b_out 0x03f8 + 4, 0x0f

        push dbg_ser_entry_msg
        extern dbg_serial_println
        call dbg_serial_println
        pop eax

        ; Now that we can log interrupts, re-enable them.
        sti
    .e:
        hlt
        jmp .e

global _lodidt
_lodidt:
	mov eax, [esp + 4]
	lidt [eax]
	ret

; ========== Interrupt Service Routines.
extern C_EX_ERR
extern C_EX_NOERR
isr_no_err_stub 0
isr_no_err_stub 1
isr_no_err_stub 2
isr_no_err_stub 3
isr_no_err_stub 4
isr_no_err_stub 5
isr_no_err_stub 6
isr_no_err_stub 7
isr_err_stub    8
isr_no_err_stub 9
isr_err_stub    10
isr_err_stub    11
isr_err_stub    12
isr_err_stub    13
isr_err_stub    14
isr_no_err_stub 15
isr_no_err_stub 16
isr_err_stub    17
isr_no_err_stub 18
isr_no_err_stub 19
isr_no_err_stub 20
isr_no_err_stub 21
isr_no_err_stub 22
isr_no_err_stub 23
isr_no_err_stub 24
isr_no_err_stub 25
isr_no_err_stub 26
isr_no_err_stub 27
isr_no_err_stub 28
isr_no_err_stub 29
isr_err_stub    30
isr_no_err_stub 31