%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int yylex();
int msg(char *);
void log_(char *, char *);
char* IntToString(int);
void empilha(int);
int desempilha();
int yyerror(char *);

extern char atomo[80];

char str[80];
int conta = 0;
int rotulo = 0;

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

programa: cabecalho           { log_("INPP", ""); } 
          variaveis
          T_INICIO 
            lista_comandos 
          T_FIM               { log_("FIMP", ""); };

cabecalho: T_PROGRAMA T_IDENTIF;

variaveis: declaracao_variaveis
         | ;

declaracao_variaveis: tipo lista_variaveis declaracao_variaveis 
                              { log_("AMEM", IntToString(conta)); } 
                    | tipo lista_variaveis
                              { log_("AMEM", IntToString(conta)); };

tipo: T_LOGICO 
    | T_INTEIRO;

lista_variaveis: T_IDENTIF    { conta++; }
                 lista_variaveis 
               | T_IDENTIF    { conta++; } ;

lista_comandos: comando lista_comandos
              | ;

comando: entrada_saida
       | repeticao
       | selecao
       | atribuicao;

entrada_saida: leitura         
             | escrita;

leitura: T_LEIA                
            { log_("LEIA", ""); }
         T_IDENTIF             
            { log_("ARZG\tx", ""); };

escrita: T_ESCREVA expressao   
            { log_("ESCR", ""); }; 

repeticao: T_ENQTO 
            { rotulo++; 
              log_("NADA", IntToString(rotulo)); 
              empilha(rotulo); }
           expressao T_FACA 
            { rotulo++; 
              log_("DSVF", IntToString(rotulo)); 
              empilha(rotulo); }
           lista_comandos T_FIMENQTO 
            { int r1 = desempilha(); 
              int r2 = desempilha();  
              log_("DSVS", IntToString(r2)); 
              log_("NADA", IntToString(r1)); }
         | T_REPITA lista_comandos T_ATE expressao T_FIMREPITA;

selecao: T_SE expressao T_ENTAO
            { log_("DSVF\tLx", ""); }
         lista_comandos T_SENAO
            { log_("DSVS\tLy", ""); printf("Lx\tNADA\n");}
         lista_comandos T_FIMSE
            { printf("Ly\tNADA\n"); } 
         ;

atribuicao: T_IDENTIF T_ATRIB expressao
            { log_("ARZG\tx", ""); };

expressao: expressao T_VEZES expressao
            { log_("MULT", ""); }
         | expressao T_DIV expressao
            { log_("DIVI", ""); }
         | expressao T_MAIS expressao
            { log_("SOMA", ""); }
         | expressao T_MENOS expressao
            { log_("SUBT", ""); }
         | expressao T_MAIOR expressao
            { log_("CMMA", ""); }
         | expressao T_MENOR expressao
            { log_("CMME", ""); }
         | expressao T_IGUAL expressao
            { log_("CMIG", ""); }
         | expressao T_E expressao
            { log_("CONJ", ""); }
         | expressao T_OU expressao
            { log_("DISJ", ""); }
         | termo; 

termo: T_IDENTIF 
            { log_("CRVG", atomo); }
     | T_NUMERO
            { log_("CRCT", atomo); }
     | T_V
            { log_("CRCT\t1", ""); }
     | T_F
            { log_("CRCT\t0", ""); }
     | T_NAO termo
            { log_("NEGA", ""); }
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

void log_(char *s, char *ref){
    printf("\t%s\t%s\n", s, ref);
}

char* IntToString(int n){
    sprintf(str, "%d", n);
    return str;
}