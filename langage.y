%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Table des symboles */
typedef struct {
    char *name;
    int value;
} Symbol;

Symbol symtab[100];
int symtab_count = 0;

void add_symbol(char *name, int value) {
    symtab[symtab_count].name = strdup(name);
    symtab[symtab_count].value = value;
    symtab_count++;
}

int get_value(char *name) {
    for(int i = 0; i < symtab_count; i++) {
        if(strcmp(symtab[i].name, name) == 0) {
            return symtab[i].value;
        }
    }
    return 0;
}

void set_value(char *name, int value) {
    for(int i = 0; i < symtab_count; i++) {
        if(strcmp(symtab[i].name, name) == 0) {
            symtab[i].value = value;
            return;
        }
    }
    add_symbol(name, value);
}
%}

%union {
    int num;
    char *id;
}

%token SCAN PRINT IF ELSE
%token INCREMENT DECREMENT
%token LT GT LE GE EQ NE
%token <num> NUMBER
%token <id> IDENTIFIER

%type <num> expression
%type <id> variable

%%

program:
    /* vide */
    | program statement
    ;

statement:
    SCAN '(' IDENTIFIER ')' ';' {
        int value;
        printf("Entrez une valeur pour %s: ", $3);
        scanf("%d", &value);
        set_value($3, value);
    }
    | PRINT '(' expression ')' ';' {
        printf("Résultat: %d\n", $3);
    }
    | IF '(' condition ')' statement {
        /* Règle pour IF simple */
    }
    | IF '(' condition ')' statement ELSE statement {
        /* Ajout de la règle pour IF-ELSE */
    }
    | IDENTIFIER '=' expression ';' {
        set_value($1, $3);
    }
    | IDENTIFIER INCREMENT ';' {
        set_value($1, get_value($1) + 1);
    }
    | IDENTIFIER DECREMENT ';' {
        set_value($1, get_value($1) - 1);
    }
    | '{' program '}'
    ;

condition:
    expression LT expression { $$ = $1 < $3; }
    | expression GT expression { $$ = $1 > $3; }
    | expression LE expression { $$ = $1 <= $3; }
    | expression GE expression { $$ = $1 >= $3; }
    | expression EQ expression { $$ = $1 == $3; }
    | expression NE expression { $$ = $1 != $3; }
    ;

expression:
    NUMBER { $$ = $1; }
    | IDENTIFIER { $$ = get_value($1); }
    | expression '+' expression { $$ = $1 + $3; }
    | expression '-' expression { $$ = $1 - $3; }
    | expression '*' expression { $$ = $1 * $3; }
    | expression '/' expression { $$ = $1 / $3; }
    | '(' expression ')' { $$ = $2; }
    ;

%%

int main() {
    symtab_count = 0;
    yyparse();
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Erreur: %s\n", s);
}
