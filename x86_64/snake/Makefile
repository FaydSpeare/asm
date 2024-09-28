all: main

main: main.o int_utils.o
	ld -o main main.o int_utils.o

int_utils.o: int_utils.asm
	nasm -f elf64 -g -F dwarf int_utils.asm -o int_utils.o

main.o:	main.asm
	nasm -f elf64 -g -F dwarf main.asm -o main.o

clean:
	rm -f int_utils.o main.o main
