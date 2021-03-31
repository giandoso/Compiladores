#include "estruturas.h"
#include <stdio.h>
#define TAM_PIL 100
int msg(char*);

int topo = -1;

void mostra_pilha(char *s){
    int i;
    printf("\n pilha (%s) = [ ", s);
    for(i=topo; i>=0; i--)
        printf("(%d, %c) ", Pilha[i].valor, Pilha[i].tipo);
    printf("]\n");
}

void empilha(int valor, int tipo){
    if(topo == TAM_PIL){
        msg("pilha cheia");
    }
    mostra_pilha("Empilha antes");
    Pilha[++topo].valor = valor;
    Pilha[topo].tipo = tipo;
    mostra_pilha("Empilha depois");
}

int desempilha(){
    if(topo == -1){
        msg("pilha vazia");
    }
    mostra_pilha("Desempilha antes");
    return Pilha[topo--].valor;
}
