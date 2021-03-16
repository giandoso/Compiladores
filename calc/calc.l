%{
#include "calc.h"
#include <stdlib.h>
void yyerror(char *);
%}

%%
[a-z]    {yylval = *yytext - 'a'; return VAR;}
[0-9]+   {yylval = atoi(yytext); return NUM;}
"+"      return MAIS;
"-"      return MENOS;
"("      return ABRE;
")"      return FECHA;
"="      return ATRIBUI;
"/"      return BARRA;
"*"      return VEZES;
\n       return ENTER;
[ \t]    ;
.        yyerror("Erro Léxico");
%%

int yywrap(void){
    return 1;
}

// Comando de compilação: 
// flex -o lex.c calc.l