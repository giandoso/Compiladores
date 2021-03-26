%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "estruturas.h"
#include "tabela.h"
#include "pilha.h"

int yylex();
int msg(char *);

void log_(char *, char *);
char* IntToString(int);
void verifica_tipo_INT();
void verifica_tipo_LOG();

int yyerror(char *);

extern char atomo[80];
extern FILE *yyin;
extern FILE *yyout;

char str[80];
int conta = 0;
int rotulo = 10;
int tipo;

enum {INT, LOG};

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
%token T_FUNC
%token T_FIMFUNC
%token T_PROC
%token T_FIMPROC
%token T_REF


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
          rotinas
          T_INICIO 
            lista_comandos 
          T_FIM               { log_("FIMP", ""); };

cabecalho: T_PROGRAMA T_IDENTIF;

variaveis: declaracao_variaveis
                              { mostra_tabela();
                                log_("AMEM", IntToString(conta)); }
         | ;

declaracao_variaveis: tipo lista_variaveis declaracao_variaveis  
                    | tipo lista_variaveis ;

tipo: T_LOGICO      {tipo = LOG;}
    | T_INTEIRO     {tipo = INT;};

lista_variaveis: lista_variaveis T_IDENTIF    
                    { strcpy(elem_tab.id, atomo);
                      elem_tab.endereco = conta;
                      elem_tab.tipo = tipo;
                      insere_simbolo(elem_tab);
                      mostra_tabela();
                      conta++; }
               | T_IDENTIF    
                      { strcpy(elem_tab.id, atomo);
                      elem_tab.endereco = conta;
                      elem_tab.tipo = tipo;
                      insere_simbolo(elem_tab);
                      mostra_tabela();
                      conta++; };

rotinas: lista_rotinas
       | ;

lista_rotinas: lista_rotinas rotina
             | rotina;

rotina: funcao
      | procedimento;

funcao: T_FUNC tipo identificador T_ABRE lista_parametros T_FECHA variaveis T_INICIO lista_comandos T_FIMFUNC;

procedimento: T_PROC identificador T_ABRE lista_parametros T_FECHA variaveis T_INICIO lista_comandos T_FIMPROC;

lista_parametros: parametro lista_parametros
                | ;

parametro: mecanismo tipo identificador;

mecanismo: T_REF
         | ;

lista_comandos: comando lista_comandos
              | ;

comando: entrada_saida
       | repeticao
       | selecao
       | atribuicao
       | chamada_procedimento;

entrada_saida: leitura         
             | escrita;

leitura: T_LEIA T_IDENTIF           
            { log_("LEIA", ""); 
              int pos = busca_simbolo(atomo);
              if(pos == -1){
                  msg("Variável não declarada");
              }
              log_("ARZG", IntToString(TabSimb[pos].endereco)); };

escrita: T_ESCREVA expressao   
            { log_("ESCR", "");
              desempilha(); }; 

repeticao: T_ENQTO 
            { rotulo++; 
              log_("NADA", IntToString(rotulo)); 
              empilha(rotulo, 'r'); }
           expressao T_FACA 
            { mostra_pilha("Repetição"); 
              int t1 = desempilha();
              if(t1 != LOG)
                  msg("Incompatibilidade de tipos!");
              rotulo++; 
              log_("DSVF", IntToString(rotulo)); 
              empilha(rotulo, 'r'); }
           lista_comandos T_FIMENQTO 
            { int r1 = desempilha(); 
              int r2 = desempilha();  
              log_("DSVS", IntToString(r2)); 
              log_("NADA", IntToString(r1)); }
         | T_REPITA lista_comandos 
            { rotulo++; 
              log_("NADA", IntToString(rotulo)); 
              empilha(rotulo, 'r'); }
           T_ATE expressao 
            { rotulo++; 
              log_("DSVF", IntToString(rotulo)); 
              empilha(rotulo, 'r'); }
           T_FIMREPITA;



selecao: T_SE expressao T_ENTAO
            { mostra_pilha("Seleção"); 
              int t1 = desempilha();
              if(t1 != LOG)
                  msg("Incompatibilidade de tipos!");
              rotulo++;
              log_("DSVF", IntToString(rotulo));
              empilha(rotulo, 'r'); }
         lista_comandos T_SENAO
            { int r = desempilha();
              rotulo++;
              log_("DSVS", IntToString(rotulo)); 
              log_("NADA", IntToString(r));
              empilha(rotulo, 'r');}
         lista_comandos T_FIMSE
            { int r = desempilha();
              log_("NADA", IntToString(r)); };

atribuicao: T_IDENTIF
            { int pos = busca_simbolo(atomo);
              if(pos == -1){
                  msg("Variável não declarada");
              }
              empilha(TabSimb[pos].endereco, 'e');
              empilha(TabSimb[pos].tipo, 't'); }
            T_ATRIB expressao
            { mostra_pilha("Atribuição"); 
              int texp = desempilha();
              int tvar = desempilha();
              int end = desempilha();
              if(texp != tvar)
                  msg("Incompatibilidade de tipos!");
              log_("ARZG", IntToString(end)); };

chamada_procedimento: identificador T_ABRE lista_argumentos T_FECHA;

lista_argumentos: lista_argumentos argumento
                | ;

argumento: expressao;

expressao: expressao T_VEZES expressao
            { verifica_tipo_INT(); 
              log_("MULT", "");
              empilha(INT, 't'); }
         | expressao T_DIV expressao
            { verifica_tipo_INT(); 
              log_("DIVI", "");
              empilha(INT, 't'); }
         | expressao T_MAIS expressao
            { verifica_tipo_INT(); 
              log_("SOMA", "");
              empilha(INT, 't'); }
         | expressao T_MENOS expressao
            { verifica_tipo_INT(); 
              log_("SUBT", "");
              empilha(INT, 't'); }
         | expressao T_MAIOR expressao
            { verifica_tipo_INT(); 
              log_("CMMA", "");
              empilha(LOG, 't'); }
         | expressao T_MENOR expressao
            { verifica_tipo_INT(); 
              log_("CMME", "");
              empilha(LOG, 't'); }
         | expressao T_IGUAL expressao
            { verifica_tipo_INT(); 
              log_("CMIG", "");
              empilha(LOG, 't'); }
         | expressao T_E expressao
            { verifica_tipo_LOG(); 
              log_("CONJ", ""); }
         | expressao T_OU expressao
            { verifica_tipo_LOG(); 
              log_("DISJ", ""); }
         | termo; 

chamada: T_ABRE lista_argumentos T_FECHA
       | ;

termo: T_IDENTIF chamada
            { int pos = busca_simbolo(atomo);
              if (pos == -1){
                  msg("Variável não declarada");
              }              
              log_("CRVG", IntToString(TabSimb[pos].endereco));
              empilha(TabSimb[pos].tipo, 't');}
     | T_NUMERO
            { log_("CRCT", atomo); 
              empilha(INT, 't'); }
     | T_V
            { log_("CRCT\t1", ""); 
              empilha(LOG, 't'); }
     | T_F
            { log_("CRCT\t0", ""); 
              empilha(LOG, 't'); }
     | T_NAO termo
            { int t1 = desempilha();
              if(t1 != LOG) msg("Incompatibilidade de tipo!");
              log_("NEGA", ""); }
     | T_ABRE expressao T_FECHA;


%%

int yyerror(char *s){
    msg("ERRO SINTATICO");
}

int main(int argc, char* argv[]){
   char *p, nameIn[100], nameOut[100];

   argv++;
   if (argc < 1)
   {
      puts("\nCompilador Simples");
      puts("Uso: ./simples <nomedoarquivo>[.simples]\n\n");
      exit(10);
   }
   p = strstr(argv[0], ".simples");
   if(p) *p=0;
   strcpy(nameIn, argv[0]);
   strcat(nameIn, ".simples");
   strcpy(nameOut, argv[0]);
   strcat(nameOut, ".mvs");

   puts(nameIn);
   puts(nameOut);

   yyin = fopen(nameIn, "rt");
   if(!yyin){
      puts("Programa fonte não encontrado!");
      exit(20);
   }

   yyout = fopen(nameOut, "wt");
   if(!yyparse()){
      printf("\nPrograma Ok!\n\n");
   }
}

void log_(char *s, char *ref){
   if(strcmp(s, "NADA") == 0){
      fprintf(yyout, "L%s\t%s\n", ref, s);
   }else if(strcmp(s, "DSVF") == 0 ||
      strcmp(s, "DSVS") == 0){
      fprintf(yyout, "\t%s\tL%s\n", s, ref);
   }else{
      fprintf(yyout, "\t%s\t%s\n", s, ref);
   } 
}

void verifica_tipo_INT(){
   int t1 = desempilha();
   int t2 = desempilha(); 

   if(t1 != INT || t2 != INT){
      msg("Incompatibilidade de tipos!");
   }
}

void verifica_tipo_LOG(){
   int t1 = desempilha();
   int t2 = desempilha(); 

   if(t1 != LOG || t2 != LOG){
      msg("Incompatibilidade de tipos!");
   }
   empilha(LOG, 't');
}
char* IntToString(int n){
    sprintf(str, "%d", n);
    return str;
}