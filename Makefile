CC = gcc
CFLAGS = -g

all: langage

langage: langage.tab.c lex.yy.c
	$(CC) $(CFLAGS) -o $@ $^ -lfl

langage.tab.c: langage.y
	bison -d langage.y

lex.yy.c: langage.l
	flex langage.l

clean:
	rm -f langage langage.tab.c langage.tab.h lex.yy.c

.PHONY: all clean
