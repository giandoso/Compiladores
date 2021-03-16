%{
#include "calc.h"
#include <stdlib.h>
void yyerror(char *);
%}

%%
[0-9]+   {yylval = atoi(yytext); return NUM;}
"+"      return MAIS;
"-"      return MENOS;
\n       return ENTER;
[ \t]    ;
.        yyerror("Erro Léxico");
%%

int yywrap(void){
    return 1;
}

// Comando de compilação: 
// flex -o lex.c calc.l