/*+−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
| UNIFAL − Universidade Federal de Alfenas
| BACHARELADO EM CIÊNCIAS DA COMPUTAÇÃO  
| Trabalho . . . : Compilador Simples − Funcao
| Disciplina  . .: Teoria de Linguagens e Compiladores
| Professor .  . : Luiz Eduardo da Silva
| Aluno . . . .. : João Pedro Giandoso
| Data . .  .. . : 30/03/2021
+−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−*/
#define TAM_TAB 100
#define TAM_PIL 100

struct{
    int valor;
    char tipo;
}Pilha[TAM_PIL], Aux[TAM_PIL];

typedef struct no{
    int tipo;
    int mec;
    struct no *prox;
}*PtNo;

struct elem_tab_simbolos{
    int hash;
    char id[30];
    int endereco;
    int tipo;
    int mecanismo;
    int rotulo;
    char escopo;
    char cat;
    int npar;
    PtNo listapar;
} TabSimb[TAM_TAB], elem_tab;