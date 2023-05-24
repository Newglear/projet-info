CC=gcc
CFLAGS=-Wall -g
BISON=bison.y
LEX=lex.l

BIN=main
OUT=main

OBJ=bison.tab.o lex.yy.o symbol_table.o ast.o

# SRCS=$(wildcard *.c)

# OBJS= symbol_table.o

all: $(BIN)

%.o: %.c %.h
	$(CC) -c $(CFLAGS) $(CPPFLAGS) $< -o $@

bison.tab.c: $(BISON)
	bison -d -t -v $<
	
lex.yy.c: $(LEX)
	flex $<


$(BIN): $(OBJ)
	$(CC) $(CFLAGS) $(CPPFLAGS) $^ -o $(OUT)



# symbol_table.o : symbol_table.c
# 	gcc $(FLAGS) -c symbol_table.c
# all: lex.c bison.c symbol_table.o
# 	gcc $(OBJS) $(FLAGS) -o main 

# all: 
# lex ./lex.l
# bison ./bison.y -d
# gcc lex.yy.c bison.tab.c -o parser
# gcc -o symbol_table symbol_table.c 
clean: 
	rm bison.tab.c bison.tab.h lex.yy.c *.o
test:
	gcc -o main test_symboltable.c symbol_table.c
	./main
	rm main
