// tabela de simbolos
#define TAM_TAB 100
int pos_tab = 0;

struct elem_tab_simbolos{
    char id[30];
    int endereço;
} TabSimb[TAM_TAB], elem_tab;

int busca_simbolo(char *id){
    int i = pos_tab -1;
    for(; strcmp(TabSimb[i].id, id) && i>=0; i--);
    return i;
}

void insere_simbolo(struct elem_tab_simbolos *elem){
    // int i = pos_tab -1;
    if(pos_tab == TAM_TAB){
        msg("OVERFLOW");
    }

    int i = 0;
    i = busca_simbolo(elem->id);

    if(i != -1){
        msg("Identificador duplicado");
    }
    TabSimb[pos_tab] = *elem;

}