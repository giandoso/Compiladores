%{
#include <stdio.h>
int yylex(void);
void yyerror(char *);  
%}

%token NUM
%token MAIS
%token MENOS
%token ENTER

%start calculo
%left MAIS MENOS

%%

calculo : calculo expr ENTER { printf("%d\n" , $2); }
        | ;

expr : NUM                   { $$ = $1; }
     | expr MAIS expr        { $$ = $1 + $3; }
     | expr MENOS expr       { $$ = $1 - $3; }
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