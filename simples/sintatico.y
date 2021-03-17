%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex();
int msg(char *);
int yyerror(char *);

%}

%token T_PROGRAMA
%token T_INICIO
%token T_FIM
%token T_IDENTIF
%token T_LEIA
%token T_ESCREVA
%token T_ENQTO
%token T_FACA
%token T_FIMENQTO
%token T_REPITA
%token T_ATE
%token T_FIMREPITA
%token T_SE
%token T_ENTAO
%token T_SENAO
%token T_FIMSE
%token T_ATRIB
%token T_VEZES
%token T_DIV
%token T_MAIS
%token T_MENOS
%token T_MAIOR
%token T_MENOR
%token T_IGUAL
%token T_EOU
%token T_NAO
%token T_V
%token T_F
%token T_NUMERO
%token T_ABRE
%token T_FECHA
%token T_INTEIRO
%token T_LOGICO


%start programa

// Precedência
%left T_E T_OU
%left T_IGUAL
%left T_MAIOR T_MENOR
%left T_MAIS T_MENOS
%left T_VEZES T_DIV

%%

programa: cabecalho variaveis T_INICIO lista_comandos T_FIM;

cabecalho: T_PROGRAMA T_IDENTIF;

variaveis: declaracao_variaveis
         | ;

declaracao_variaveis: tipo lista_variaveis declaracao_variaveis
                    | tipo lista_variaveis;

tipo: T_LOGICO 
    | T_INTEIRO;

lista_variaveis: T_IDENTIF lista_variaveis 
               | T_IDENTIF ;

lista_comandos: comando lista_comandos
              | ;

comando: entrada_saida
       | repeticao
       | selecao
       | atribuicao;

entrada_saida: leitura 
             | escrita;

leitura: T_LEIA T_IDENTIF;

escrita: T_ESCREVA expressao;

repeticao: T_ENQTO expressao T_FACA lista_comandos T_FIMENQTO
         | T_REPITA lista_comandos T_ATE expressao T_FIMREPITA;

selecao: T_SE expressao T_ENTAO lista_comandos T_SENAO lista_comandos T_FIMSE;

atribuicao: T_IDENTIF T_ATRIB expressao;

expressao: expressao T_VEZES expressao
         | expressao T_DIV expressao
         | expressao T_MAIS expressao
         | expressao T_MENOS expressao
         | expressao T_MAIOR expressao
         | expressao T_MENOR expressao
         | expressao T_IGUAL expressao
         | expressao T_E expressao
         | expressao T_OU expressao
         | termo; 

termo: T_IDENTIF 
     | T_NUMERO
     | T_V
     | T_F
     | T_NAO termo
     | T_ABRE expressao T_FECHA;


%%

int yyerror(char *s){
    msg("ERRO SINTATICO");
}

int main(void){
    if(!yyparse()){
        printf("Programa Ok!\n\n");
    }
}