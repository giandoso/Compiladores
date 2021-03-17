#include "tree.h"
#include "calc.h"
#include <stdlib.h>
#include <stdio.h>

ptno criaNo(int tipo, int valor){
    ptno n = (ptno)malloc(sizeof(struct no));
    n->tipo = tipo;
    n->valor = valor;
    n->filho = NULL;
    n-> irmao = NULL;
    return n;
}


void adicionaFilho(ptno pai, ptno filho){
    if(filho){
        filho->irmao = pai->filho;
        pai->filho = filho;
    }
}

void mostra(ptno raiz, int nivel){
    ptno p;
    int i; 
    for(i=0;i<nivel;i++){
        printf("    ");
    }
    switch(raiz->tipo){
        case NUM:
            printf("Valor:%d\n", raiz->valor);
            break;
        case VAR:
            printf("Variavel:%d\n", raiz->valor);
            break;
        case IGUAL:
            printf("Atribui\n");
            break;
        case MAIS:
            printf("Soma\n");
            break;
        case MENOS:
            printf("Subtrai\n");
            break;
        case VEZES:
            printf("Multiplica\n");
            break;
    }
    p = raiz->filho;
    while(p){
        mostra(p, nivel+1);
        p = p->irmao;
    }

}