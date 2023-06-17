all: main

main: main.o int_utils.o
	ld -o main main.o int_utils.o

int_utils.o: int_utils.asm
	nasm -f elf64 int_utils.asm -o int_utils.o

main.o:	main.asm
	nasm -f elf64 main.asm -o main.o

clean:
	rm -f int_utils.o main.o main
