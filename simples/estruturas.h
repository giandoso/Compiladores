#define TAM_TAB 100
#define TAM_PIL 100

struct{
    int valor;
    char tipo;
}Pilha[TAM_PIL];

struct elem_tab_simbolos{
    char id[30];
    int endereco;
    int tipo;
} TabSimb[TAM_TAB], elem_tab;