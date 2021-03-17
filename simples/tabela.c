#include "estruturas.h"
#include <string.h>
#include <stdio.h>

int pos_tab = 0;
void msg(char *);


int busca_simbolo(char *id){
    int i = pos_tab -1;
    for(; strcmp(TabSimb[i].id, id) && i>=0; i--);
    return i;
}

void insere_simbolo(struct elem_tab_simbolos elem){
    // int i = pos_tab -1;
    if(pos_tab == TAM_TAB){
        msg("OVERFLOW");
    }

    int i = 0;
    i = busca_simbolo(elem.id);

    if(i != -1){
        msg("Identificador duplicado");
    }
    TabSimb[pos_tab] = elem;
    pos_tab++;
}

void mostra_tabela(){
    int i = 0;
    int ligado = 0; // ligar debug aqui, mudando para 1
    if(ligado == 1){
        printf("\n%30s %s", "ID", "END");
        for(i = pos_tab - 1; i >= 0; i--){
            printf("\n%30s %d", TabSimb[i].id, TabSimb[i].endereco);
        }
        printf("\n\n");
    }
}