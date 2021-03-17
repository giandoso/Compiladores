%{
#include "sintatico.h"
int numLinha=1;
char atomo[80];
void msg(char *);
void log_(char *, char *);
%}

identificador  [a-zA-Z]([a-zA-Z0-9])*
numero         [0-9]+
espaco         [ \t\r]+
novalinha      [\n]

%x comentario

%%

programa    return T_PROGRAMA;
inicio      return T_INICIO;
fimprograma return T_FIM;

leia        return T_LEIA;
escreva     return T_ESCREVA;

se          return T_SE;
entao       return T_ENTAO;
senao       return T_SENAO;
fimse       return T_FIMSE;

enquanto    return T_ENQTO;
faca        return T_FACA;
fimenquanto return T_FIMENQTO;

repita      return T_REPITA;
ate         return T_ATE;
fimrepita   return T_FIMREPITA;

"+"         return T_MAIS;
"-"         return T_MENOS;
"*"         return T_VEZES;
div         return T_DIV;

">"         return T_MAIOR;
"<"         return T_MENOR;
"="         return T_IGUAL;

e           return T_E;
ou          return T_OU ;
nao         return T_NAO;

"<-"        return T_ATRIB;
"("         return T_ABRE;
")"         return T_FECHA;

inteiro     return T_INTEIRO;
log_ico      return T_LOGICO;
V           return T_V;
F           return T_F;

{identificador}  {strcpy(atomo, yytext); return T_IDENTIF;}
{numero}         {strcpy(atomo, yytext); return T_NUMERO;}
{espaco}         /* nao faz nada */
{novalinha}      /* nao faz nada */

"//".*           /* nao faz nada */ 
"/*"             BEGIN(comentario);
<comentario>"*/" BEGIN(INITIAL);
<comentario>.    /* nao faz nada */ 
<comentario>\n   numLinha++;

.                msg("ERRO - SIMBOLO NAO RECONHECIDO!\n");

%%

int yywrap(void) { return 1; }

void msg(char *s){ 
    printf("\n%d: %s\n\n", numLinha, s);
    exit(10);
}
