
all: principal

y.tab.c: terminal.y
	yacc terminal.y

y.tab.h: terminal.y
	yacc -d terminal.y

lex.yy.c: arch.lex
	lex arch.lex

lex.yy.o: lex.yy.c y.tab.h
	gcc -c lex.yy.c 

y.tab.o: y.tab.c
	gcc -c y.tab.c 

pila.o: pila.c
	gcc -c pila.c

principal: lex.yy.o y.tab.o y.tab.h pila.o 
	gcc lex.yy.o y.tab.o pila.o -o term -lm

clean: 
	rm y.tab.h lex.yy.c y.tab.c y.tab.o lex.yy.o