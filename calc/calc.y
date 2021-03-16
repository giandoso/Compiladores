%{
#include <stdio.h>
int yylex(void);
void yyerror(char *);  
int valores[26];
%}

%token NUM
%token MAIS
%token MENOS
%token ABRE
%token FECHA
%token ATRIBUI
%token BARRA
%token VEZES
%token VAR
%token ENTER


%start calculo

// Precedência
%left MAIS MENOS   // associatividade
%left VEZES BARRA

%%

calculo : calculo comando ENTER 
        | ;

comando : expr               { printf("%d\n", $1); }
        | VAR ATRIBUI expr   { valores[$1] = $3; }

expr : NUM                   { $$ = $1; }
     | VAR                   { $$ = valores[$1]; }
     | expr MAIS expr        { $$ = $1 + $3; }
     | expr MENOS expr       { $$ = $1 - $3; }
     | expr BARRA expr       { $$ = $1 / $3; }
     | expr VEZES expr       { $$ = $1 * $3; }
     | ABRE expr FECHA       { $$ = $2; }
     ;                       

%%

void yyerror(char *s){
    printf("%s\n", s);
}

int main(void){
    yyparse();
    return 0;
}

// Comando de compilação:
// bison -v -d -g calc.y -o calc.c
//
// Comando de execução: 
// gcc lex.c calc.c -o calc