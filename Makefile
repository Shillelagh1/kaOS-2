build:
	rm tmp -r -f
	mkdir tmp
	@echo
	#
	# ==== Boot File ====
	nasm -felf32 src/boot.s -o tmp/boot.o
	
	@echo
	#
	# ==== Linking ====
	rm bin -r -f
	mkdir bin
	$$HOME/opt/cross/bin/i686-elf-gcc -T src/LINKER.ld -ffreestanding -O2 -nostdlib -lgcc
	grub-file --is-x86-multiboot bin/kaOS2.bin
	-@echo $$?

	@echo
	#
	# ==== Pack into image ====
	mkdir -p tmp/iso/boot/grub
	cp bin/kaOS2.bin tmp/iso/boot/kaOS2.bin
	cp src/grub.cfg tmp/iso/boot/grub/grub.cfg
	grub-mkrescue -o bin/kaOS2.iso tmp/iso

run: build
	qemu-system-i386 -cdrom bin/kaOS2.iso -monitor stdio

exp: build
	-rm /media/sf_shared/kaOS2.iso
	cp bin/kaOS2.iso /media/sf_shared/kaOS2.iso