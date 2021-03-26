#define TAM_TAB 100
#define TAM_PIL 100

struct{
    int valor;
    char tipo;
}Pilha[TAM_PIL];

typedef struct no *lista;
struct no{
    int tipo;
    int mec;
    lista prox;
}; // TODO: Criar metodos de inserção e deleção 

struct elem_tab_simbolos{
    char id[30];
    int endereco; // TODO: O que fazer com o endereço? 
    int tipo;
    int mecanismo;
    int rotulo;
    char escopo;
    char cat;
    int npar;
    lista listapar;
} TabSimb[TAM_TAB], elem_tab;