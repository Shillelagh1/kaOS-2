ENTRY(_start)
INPUT
(
    tmp/boot.o
	tmp/boot_idt_setup.o
	tmp/c_dbg_serial.o
)
OUTPUT(bin/kaOS2.bin)

SECTIONS
{
	. = 2M;

	.text BLOCK(4K) : ALIGN(4K)
	{
		_kernel_start = .;
		*(.multiboot)
		*(.text)
	}

	.rodata BLOCK(4K) : ALIGN(4K)
	{
		*(.rodata)
	}

	.data BLOCK(4K) : ALIGN(4K)
	{
		*(.data)
	}

	.bss BLOCK(4K) : ALIGN(4K)
	{
		*(COMMON)
		*(.bss)
	}

	_kernel_end = .;
}
