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