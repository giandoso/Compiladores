%{
#include <stdio.h>
#include <stdlib.h>
#include "tree.h"

#define YYSTYPE ptno

int yylex(void);
void yyerror(char *);  

ptno raiz = NULL, pt;
int valores[26];
%}

%token NUM
%token MAIS
%token MENOS
%token ABRE
%token FECHA
%token IGUAL
%token BARRA
%token VEZES
%token VAR
%token ENTER


%start programa

// Precedência
%left MAIS MENOS   // associatividade
%left VEZES BARRA

%%


programa : 
         programa calculo ENTER { 
            raiz = $2;
            mostra(raiz, 0);
         }
         | ;

calculo : expr { $$ = $1; } 
        | VAR IGUAL expr { 
            pt = criaNo(IGUAL, 0);
            adicionaFilho(pt, $3);
            adicionaFilho(pt, $1);
            $$ = pt;
        }
        ;

expr : NUM                   { $$ = $1; }
     | VAR                   { $$ = $1; }
     | expr MAIS expr        { 
         pt = criaNo(MAIS, 0);
         adicionaFilho(pt, $3);
         adicionaFilho(pt, $1);
         $$ = pt;
     }
     | expr MENOS expr       { 
         pt = criaNo(MENOS, 0);
         adicionaFilho(pt, $3);
         adicionaFilho(pt, $1);
         $$ = pt;
     }
     | expr BARRA expr       { 
         pt = criaNo(BARRA, 0);
         adicionaFilho(pt, $3);
         adicionaFilho(pt, $1);
         $$ = pt;
     }
     | expr VEZES expr       {
         pt = criaNo(VEZES, 0);
         adicionaFilho(pt, $3);
         adicionaFilho(pt, $1);
         $$ = pt;
     }
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