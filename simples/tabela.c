#include "estruturas.h"
#include <string.h>
#include <stdio.h>

int pos_tab = 0;
void msg(char *);

void maiuscula(char *s){
    int i;
    for(i = 0; s[i]; i++){
        s[i] = toupper(s[i]);
    }
}

int busca_simbolo(char *id){
    int i = pos_tab -1;
    //maiuscula(id);
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
    //maiuscula(elem.id);
    TabSimb[pos_tab] = elem;
    pos_tab++;
}

void mostra_tabela(){
    int i = 0;
    int ligado = 1; // ligar debug aqui, mudando para 1
    if(ligado == 1){
        puts("Tabela de simbolos");
        printf("\n%30s | %s | %s", "ID", "END", "TIP");
        for(i = 0; i < pos_tab ; i++){
            printf("\n%30s | %3d | %3d", TabSimb[i].id, TabSimb[i].endereco, TabSimb[i].tipo);
        }
        printf("\n\n");
    }
}