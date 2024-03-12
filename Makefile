# Author: Éder Augusto Penharbel

.PHONY: clean image

all: image

floppy.img:
	dd if=/dev/zero of=$@ bs=512 count=2880

loader.o: loader.s
	as $< -o $@

loader.bin: loader.o
	ld --Ttext 0x7c00 --Tdata 0x7d00 --oformat=binary loader.o -o loader.bin

main.o: main.s
	as $< -o $@

main.bin: main.o
	ld --Ttext 0x8000 --oformat=binary main.o -o main.bin

image: main.bin loader.bin floppy.img
	dd if=loader.bin of=floppy.img bs=512 count=1 conv=notrunc
	dd if=main.bin of=floppy.img bs=1024 count=1 seek=1 conv=notrunc
	
# deletar arquivos 
clean:
	$(RM) -f floppy.img
	$(RM) -f loader.o
	$(RM) -f loader.bin
	$(RM) -f main.o
	$(RM) -f main.bin
	