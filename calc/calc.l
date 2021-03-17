%{
#include "tree.h"
#define YYSTYPE ptno
#include "calc.h"
void yyerror(char *);
%}

%%
[a-z]    {
            yylval = criaNo (VAR, *yytext - 'a'); 
            return VAR;
         }
[A-Z]    {yylval = criaNo(VAR, *yytext - 'A'); return VAR;}
[0-9]+   {yylval = criaNo(NUM, atoi(yytext)); return NUM;}
"+"      return MAIS;
"-"      return MENOS;
"("      return ABRE;
")"      return FECHA;
"="      return IGUAL;
"/"      return BARRA;
"*"      return VEZES;
\n       return ENTER;
[ \t]    ;
.        yyerror("Simbolo invalido");
%%

int yywrap(void){
    return 1;
}
