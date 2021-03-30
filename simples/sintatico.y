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
int popula_deslocamento();
void remove_variaveis_locais(int, int);
void mostra_lista(PtNo);
PtNo insere(PtNo, int, int);

int yyerror(char *);

extern char atomo[80];
extern FILE *yyin;
extern FILE *yyout;

char str[80];
int conta = 0;
int rotulo = 0;
int tipo;
int mecanismo;
char escopo;
int categoria;
int npar;
int nvar_g;
int nvar_l;
PtNo parametros = NULL;

int ehVariavel;
int ehReferencia;

enum {INT = 1, LOG, VAL=10, REF};

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

programa: cabecalho           { log_("INPP", ""); escopo = 'G';} 
          variaveis
          rotinas
          T_INICIO 
            lista_comandos 
          T_FIM               { if(nvar_g > 0)
                                 log_("DMEM", IntToString(nvar_g));
                                log_("FIMP", ""); };

cabecalho: T_PROGRAMA T_IDENTIF;

variaveis: declaracao_variaveis
                              { char c = escopo == 'G' ? nvar_g : nvar_l;
                                log_("AMEM", IntToString(c)); }
         | ;

declaracao_variaveis: tipo lista_variaveis declaracao_variaveis  
                    | tipo lista_variaveis ;

tipo: T_LOGICO      {tipo = LOG;}
    | T_INTEIRO     {tipo = INT;} ;

lista_variaveis: lista_variaveis T_IDENTIF    
                  { categoria = 'V';
                     strcpy(elem_tab.id, atomo);
                     elem_tab.hash = conta;
                     elem_tab.endereco = escopo == 'G' ? nvar_g : nvar_l;
                     elem_tab.tipo = tipo;
                     elem_tab.mecanismo = -1;
                     elem_tab.rotulo = -1;
                     elem_tab.escopo = escopo;
                     elem_tab.cat = categoria;
                     elem_tab.npar = 0; // TODO: 
                     insere_simbolo(elem_tab);
                     // mostra_tabela();
                     if(escopo == 'L') nvar_l++;
                     if(escopo == 'G') nvar_g++;  
                     conta++; }
               | T_IDENTIF    
                  { categoria = 'V';
                     strcpy(elem_tab.id, atomo);
                     elem_tab.hash = conta;
                     elem_tab.endereco = escopo == 'G' ? nvar_g : nvar_l;
                     elem_tab.tipo = tipo;
                     elem_tab.mecanismo = -1;
                     elem_tab.rotulo = -1;
                     elem_tab.escopo = escopo;
                     elem_tab.cat = categoria;
                     elem_tab.npar = 0; // TODO: 
                     insere_simbolo(elem_tab);
                     // mostra_tabela();
                     if(escopo == 'L') nvar_l++;
                     if(escopo == 'G') nvar_g++;  
                     conta++; };

rotinas: { log_("DSVS", IntToString(rotulo));
           empilha(rotulo, 'r'); }
         lista_funcoes 
         { int r = desempilha();
           log_("NADA", IntToString(r)); } 
       | ; 

lista_funcoes: funcao lista_funcoes
             | funcao;

funcao: T_FUNC tipo identificador 
         { // insere nome na tabela
           categoria = 'F'; 
           rotulo++;
           strcpy(elem_tab.id, atomo);
           elem_tab.hash = conta;
           elem_tab.endereco = conta;
           elem_tab.tipo = tipo;
           elem_tab.mecanismo = -1;
           elem_tab.rotulo = rotulo;
           elem_tab.escopo = escopo;
           elem_tab.cat = categoria;
           elem_tab.npar = 0; 
           insere_simbolo(elem_tab);
           puts("funcao");
         //   mostra_tabela();
           log_("ENSP", IntToString(rotulo));
           empilha(rotulo, 'r');
           conta++;
           // mudar o escopo para local
           escopo = 'L';
           parametros = NULL;
           npar = 0; 
           nvar_l = 0;
         }
        T_ABRE
        lista_parametros T_FECHA
         { //Ajustar deslocamentos e incluir lista de parametros
           npar = popula_deslocamento(parametros);
         }
        variaveis
        T_INICIO lista_comandos T_FIMFUNC
         {  //remover variaveis locais
            remove_variaveis_locais(npar, nvar_l);
            //mudar o escopo para global
            if(nvar_l > 0)
              log_("DMEM", IntToString(nvar_l));
            log_("RTSP", IntToString(npar));
            int r = desempilha();
            escopo = 'G';
         }
        ;

lista_parametros: lista_parametros parametro 
                | { categoria = 'P';};

parametro: mecanismo tipo identificador
            { // incluir o parametros na tabela de simbolos
               strcpy(elem_tab.id, atomo);
               elem_tab.hash = conta;
               elem_tab.endereco = conta;
               elem_tab.tipo = tipo;
               elem_tab.mecanismo = mecanismo;
               elem_tab.rotulo = -1;
               elem_tab.escopo = escopo;
               elem_tab.cat = categoria;
               elem_tab.npar = 0; 
               insere_simbolo(elem_tab);
               puts("parametro");
               // mostra_tabela();
               parametros = insere(parametros, tipo, mecanismo);
               conta++;
            };

mecanismo: T_REF { mecanismo = REF; }
         |       { mecanismo = VAL; };

lista_comandos: comando lista_comandos
              | ;

comando: entrada_saida
       | repeticao
       | selecao
       | atribuicao;

entrada_saida: leitura         
             | escrita;

identificador: T_IDENTIF
               {
                  //int i = busca_simbolo(atomo);
                  //if( i== -1 )
                  //   msg("Identificador desconhecido!");
                  //empilha(i, 'i'); 
                  // empilhar a posição do id na tabsimb
                  //empilha(TabSimb[i].endereco, 'e');
               };

leitura: T_LEIA T_IDENTIF           
            { log_("LEIA", ""); 
              // gerar ARMI se a leitura eh para um parametro por referencia
              if(escopo == 'L' && mecanismo == REF){
                  int pos = busca_simbolo(atomo, escopo);
                  if(pos == -1)
                     msg("Variável não declarada");
                  // TODO: Calcular o endereço do ARMI direito
                  log_("ARMI", IntToString(TabSimb[pos].endereco));
                  
              }
              // gerar ARZL para parametro por valor ou variavel local
              if(escopo == 'L' && mecanismo == VAL){
                  int pos = busca_simbolo(atomo, escopo);
                  if(pos == -1)
                     msg("Variável não declarada");
                  log_("ARZL", IntToString(TabSimb[pos].endereco));
              }
              // gerar ARZG para variavel global;
              if(escopo == 'G'){
                  int pos = busca_simbolo(atomo, escopo);
                  if(pos == -1)
                     msg("Variável não declarada");
                  log_("ARZG", IntToString(TabSimb[pos].endereco));
              }
              };
              

escrita: T_ESCREVA expressao   
            { log_("ESCR", "");
              desempilha(); }; 

repeticao: T_ENQTO 
            { rotulo++; 
              log_("NADA", IntToString(rotulo)); 
              empilha(rotulo, 'r'); }
           expressao T_FACA 
            { //mostra_pilha("Repetição"); 
              int t1 = desempilha();
              if(t1 != LOG)
                  msg("Enquanto > Incompatibilidade de tipos!");
              rotulo++; 
              log_("DSVF", IntToString(rotulo)); 
              empilha(rotulo, 'r'); }
           lista_comandos T_FIMENQTO 
            { int r1 = desempilha(); 
              int r2 = desempilha();  
              log_("DSVS", IntToString(r2)); 
              log_("NADA", IntToString(r1)); }
         | T_REPITA 
            { rotulo++; 
              log_("NADA", IntToString(rotulo)); 
              empilha(rotulo, 'r'); }
            lista_comandos 
            
           T_ATE expressao 
            {  int t1 = desempilha();
               if(t1 != LOG)
                  msg("Repita > Incompatibilidade de tipos!");
               int r = desempilha(); 
               log_("DSVF", IntToString(r)); }
           T_FIMREPITA;



selecao: T_SE expressao T_ENTAO
            { //mostra_pilha("Seleção"); 
              int t1 = desempilha();
              if(t1 != LOG)
                  msg("Selecao > Incompatibilidade de tipos!");
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
            { 
               int pos = busca_simbolo(atomo, escopo);
               if(pos == -1)
               msg("Variável não declarada");
               empilha(TabSimb[pos].endereco, 'e');
               empilha(TabSimb[pos].tipo, 't'); 
               printf("debug atribuicao > T_IDENTIF | %s\n", atomo); }

            T_ATRIB expressao
            {  //mostra_pilha("Atribuição"); 
               int texp = desempilha();
               int tvar = desempilha();
               if(texp != tvar)
                     msg("Incompatibilidade de tipos!"); 
               int end = desempilha();
               int pos = busca_hash(end);
               
               // printf(" Debug Atribuição | Atomo = %s | ESC = %c | CAT = %s", atomo, TabSimb[pos].cat, TabSimb[pos].cat);
               
               if(TabSimb[pos].cat == 'P' && TabSimb[pos].mecanismo == REF)
                  // gerar ARMI se a atribuicao eh um parametro por referencia
                  log_("ARMI", IntToString(end));
               if((TabSimb[pos].cat == 'P' && TabSimb[pos].mecanismo == VAL) ||
                  (TabSimb[pos].cat == 'V' && TabSimb[pos].escopo == 'L')    ||
                  (TabSimb[pos].cat == 'F'))
                  // gerar ARZL para parametro por valor ou variavel local ou nome de funcao
                  log_("ARZL", IntToString(end));
               if(TabSimb[pos].cat == 'V' && TabSimb[pos].escopo == 'G')
                  // gerar ARZG para variavel global
                  log_("ARZG", IntToString(end));
               
            };


chamada_funcao:   identificador T_ABRE
                  {  printf("\nDebug chamada função  %s %c\n", atomo, escopo);
                     int pos = busca_simbolo(atomo, escopo);
                     if(pos == -1)
                        msg("Variável não declarada");
                     
                     log_("AMEM", "1");
                     empilha(TabSimb[pos].rotulo, 'r');
                     parametros = TabSimb[pos].listapar; }
                  argumentos 
                  // { printf("\nDebug chamada função  %s %c\n", atomo, escopo); }
                  T_FECHA
                  {
                     int r = desempilha();
                     log_("SVCP", "");
                     log_("DSVS", IntToString(r));

                  };


argumentos: lista_argumentos 
            // comparar numero de argumentos com o numero de parametros
            | 
            // contar argumentos
            {printf("\nDebug conta argumentos %s %c\n", atomo, escopo);
            mostra_lista(parametros);
            }
            ;

lista_argumentos: lista_argumentos argumento
               //  { printf("\nDebug argumentos>lista_argumentos>lista arg %s %c\n", atomo, escopo); }
                | 
                { printf("\nDebug argumentos>lista_argumentos>arg %s %c\n", atomo, escopo); 
                  mostra_lista(parametros);
                  parametros = parametros->prox == NULL ? parametros : parametros->prox;
                };

argumento: expressao
         {
            printf("\nDebug argumentos>expressão %s %c\n", atomo, escopo);
            mostra_lista(parametros);
            parametros = parametros->prox == NULL ? parametros : parametros->prox;
            // ehVariavel é para decidir se um parâmetro por referência está recebendo uma variável.
            // ehReferencia é para sinalizar que o parâmetro correspondente ao argumento é por referência
            // TODO: comparar tipo e categoria do argumento com o parametro
            // (somente variaveis podem ser passadas por referencia)
         };

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
              log_("CONJ", "");
              empilha(LOG, 't'); }
         | expressao T_OU expressao
            { verifica_tipo_LOG(); 
              log_("DISJ", "");
              empilha(LOG, 't'); }
         | termo;

termo: identificador
            { 
               int pos = busca_simbolo(atomo, escopo);
               if(pos == -1)
                  msg("Variável não declada!");
               printf("Debug termo>identificador | %s\n", atomo);

               if(TabSimb[pos].escopo == 'G' && TabSimb[pos].mecanismo == REF && TabSimb[pos].cat == 'V'){
                  // gerar CREG - Se a variavel é global e a passagem por referencia 
                  log_("CREG", IntToString(TabSimb[pos].endereco));
                  empilha(TabSimb[pos].tipo, 't'); 
               }else if(TabSimb[pos].escopo == 'L' && TabSimb[pos].mecanismo == REF && TabSimb[pos].cat == 'V'){
                  // gerar CREL - Se a variavel é local e a passagem por referencia
                  log_("CREL", IntToString(TabSimb[pos].endereco));
                  empilha(TabSimb[pos].tipo, 't');
               }else if(TabSimb[pos].escopo == 'L' && TabSimb[pos].mecanismo == VAL){
                  // gerar CRVL - Se a variavel é local e a passagem por valor ou 
                  //            - Se a variavel é por referencia e a passagem por referencia (TODO: ?)
                  //              Acessando argumento por valor
                  log_("CRVL", IntToString(TabSimb[pos].endereco));
                  empilha(TabSimb[pos].tipo, 't');
               }else if(TabSimb[pos].mecanismo == REF){
                  // gerar CRVI - Se a variavel eh por referencia e a passagem por valor (TODO: ?)
                  //            - Acessando argumento por referencia 
                  log_("CRVI", IntToString(TabSimb[pos].endereco));
                  empilha(TabSimb[pos].tipo, 't');
               }else if(TabSimb[pos].escopo == 'G' && TabSimb[pos].cat == 'V'){
                  // gerar CRvG - Se a variavel é global
                  log_("CRVG", IntToString(TabSimb[pos].endereco));
                  empilha(TabSimb[pos].tipo, 't');
               } 
               
            }
     | T_NUMERO
            { 
               printf("Debug termo>numero | %s\n", atomo);
               log_("CRCT", atomo); 
               empilha(INT, 't'); }
     | T_V
            { log_("CRCT\t1", ""); 
              empilha(LOG, 't'); }
     | T_F
            { log_("CRCT\t0", ""); 
              empilha(LOG, 't'); }
     | T_NAO termo
            { int t1 = desempilha();
              if(t1 != LOG) msg("T_NAO > Incompatibilidade de tipo!");
              log_("NEGA", "");
              empilha(LOG, 't'); }
     | T_ABRE expressao T_FECHA;
     | chamada_funcao;


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
   if(strcmp(s, "NADA") == 0 ||
      strcmp(s, "ENSP") == 0){
      fprintf(yyout, "L%s\t%s\n", ref, s);
      printf("L%s\t%s\n", ref, s);
   }else if(strcmp(s, "DSVF") == 0 ||
            strcmp(s, "DSVS") == 0){
      fprintf(yyout, "\t%s\tL%s\n", s, ref);
      printf("\t%s\tL%s\n", s, ref);
   }else if(strcmp(s, "RTSP") == 0){
      fprintf(yyout, "\t%s\t%s\n", s, ref);
      printf("\t%s\t%s\n", s, ref);
   }else if(strcmp(ref, "") == 0){
      fprintf(yyout, "\t%s\n", s);
      printf("\t%s\n", s);
   }else{
      fprintf(yyout, "\t%s\t%s\n", s, ref);
      printf("\t%s\t%s\n", s, ref);
   } 
}

void verifica_tipo_INT(){
   // mostra_pilha("verifica tipo int");
   int t1 = desempilha();
   int t2 = desempilha(); 
   // mostra_pilha("verifica tipo int");
   if(t1 != INT || t2 != INT){
      msg("Verifica_tipo_INT > Incompatibilidade de tipos!");
   }
}

void verifica_tipo_LOG(){
   int t1 = desempilha();
   int t2 = desempilha(); 

   if(t1 != LOG || t2 != LOG){
      msg("Verifica_tipo_LOG > Incompatibilidade de tipos!");
   }
}
char* IntToString(int n){
    sprintf(str, "%d", n);
    return str;
}