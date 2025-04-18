%{
#include "langage.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%%

[ \t\n]       ; /* Ignorer les espaces blancs */

"A9RA"        { return SCAN; }
"EKTEB"       { return PRINT; }
"KEN"         { return IF; }
"KENLE"       { return ELSE; }
"++"          { return INCREMENT; }
"--"          { return DECREMENT; }

"="           { return '='; }
"+"           { return '+'; }
"-"           { return '-'; }
"*"           { return '*'; }
"/"           { return '/'; }
";"           { return ';'; }
"("           { return '('; }
")"           { return ')'; }
"{"           { return '{'; }
"}"           { return '}'; }

"<"           { return LT; }
">"           { return GT; }
"<="          { return LE; }
">="          { return GE; }
"=="          { return EQ; }
"!="          { return NE; }

[0-9]+        { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]* { yylval.id = strdup(yytext); return IDENTIFIER; }

.             { printf("Caractère inconnu: %s\n", yytext); }

%%

int yywrap() {
    return 1;
}
