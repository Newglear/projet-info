all: 
	lex ./lex.l
	bison ./bison.y -d
	gcc -o symbol_table symbol_table.c 
clean: 
	rm bison.tab.c bison.tab.h lex.yy.c
test:
	gcc -o main test_symboltable.c symbol_table.c
	./main
	rm main
