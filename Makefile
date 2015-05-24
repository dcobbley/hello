#----------------------------------------------------------------------------
include ../Makefile.common

all:	cdrom.iso

run:	cdrom.iso
	$(QEMU) -m 32 -serial stdio -cdrom cdrom.iso

cdrom.iso: cdrom
	grub-mkrescue -o cdrom.iso cdrom

# make a basic cdrom image
cdrom: grub.cfg hello
	mkdir -p cdrom/boot/grub
	cp grub.cfg cdrom/boot/grub
	cp hello cdrom
	touch cdrom

OBJS   = boot.o hello.o

hello: ${OBJS} hello.ld
	$(LD) -T hello.ld -o hello ${OBJS} --print-map > hello.map
	strip hello

boot.o: boot.s
	$(CC) -Wa,-alsm=boot.lst -c -o boot.o boot.s

hello.o: hello.c
	$(CC) ${CCOPTS} -o hello.o -c hello.c

#----------------------------------------------------------------------------
# tidy up after ourselves ...
clean:
	-rm -rf cdrom cdrom.iso hello *.o *.lst *.map

#----------------------------------------------------------------------------
