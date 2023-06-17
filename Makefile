all: main

main: main.o read_int.o
	ld -o main main.o read_int.o

read_int.o: read_int.asm
	nasm -f elf64 read_int.asm -o read_int.o

main.o:	main.asm
	nasm -f elf64 main.asm -o main.o

clean:
	rm -f read_int.o main.o main
