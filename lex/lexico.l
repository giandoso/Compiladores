identificador  [a-zA-Z]([a-zA-Z0-9])*
numero         [0-9]+
espaco         [ \t\r]+
novalinha      [\n]

%%
programa    printf("Reservada....: %s\n", yytext);
inicio      printf("Reservada....: %s\n", yytext);
fimprograma printf("Reservada....: %s\n", yytext);

leia        printf("Reservada....: %s\n", yytext);
escreva     printf("Reservada....: %s\n", yytext);

se          printf("Reservada....: %s\n", yytext);
entao       printf("Reservada....: %s\n", yytext);
senao       printf("Reservada....: %s\n", yytext);
fimse       printf("Reservada....: %s\n", yytext);

enquanto    printf("Reservada....: %s\n", yytext);
faca        printf("Reservada....: %s\n", yytext);
fimenquanto printf("Reservada....: %s\n", yytext);

"+"         printf("Operador.....: %s\n", yytext);
"-"         printf("Operador.....: %s\n", yytext);
"*"         printf("Operador.....: %s\n", yytext);
div         printf("Operador.....: %s\n", yytext);

">"         printf("Operador.....: %s\n", yytext);
"<"         printf("Operador.....: %s\n", yytext);
"="         printf("Operador.....: %s\n", yytext);

e           printf("Operador.....: %s\n", yytext);
ou          printf("Operador.....: %s\n", yytext);
nao         printf("Operador.....: %s\n", yytext);

"<-"        printf("Operador.....: %s\n", yytext);
"("         printf("Operador.....: %s\n", yytext);
")"         printf("Operador.....: %s\n", yytext);

inteiro     printf("Tipo.........: %s\n", yytext);
logico      printf("Tipo.........: %s\n", yytext);
V           printf("Tipo.........: %s\n", yytext);
F           printf("Tipo.........: %s\n", yytext);

{identificador} printf("Identificador: %s\n", yytext);
{numero}        printf("Número.......: %s\n", yytext);
{espaco}        /* nao faz nada */
{novalinha}     /* nao faz nada */
["]+.+["]+      printf("Literal......: %s\n", yytext);
.               printf("%s: ERRO - SIMBOLO NAO RECONHECIDO!\n", yytext);

%%
int yywrap(void) { return 1; }

int main (void) {
   yylex();
   return 0;
}
