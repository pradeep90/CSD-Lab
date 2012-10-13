# Makefile for Merge Sort program - [2012-08-12 Sun]

merge-sort: merge-sort.asm io.mac
	nasm -g -f elf -l merge-sort.lst merge-sort.asm 
	ld -s merge-sort.o io.o
