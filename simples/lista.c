#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#include "estruturas.h"

void mostraLista(PtNo L){
	printf("[");
	while(L){
		printf("%d | %d", L->tipo, L->mec);
		L=L->prox;
		if(L){
			printf(", ");
		}	
	}
		printf("]\n");
}

PtNo insere(PtNo L, int tipo, int mec){
	PtNo aux, ant, p;
	p=(PtNo)malloc(sizeof(struct no));
	if(!p) printf ("\nLISTA_CHEIA");
	else{
		ant=NULL;
		aux=L;
		while (aux){
			ant=aux;
			aux=aux->prox;
		}
		p->tipo = tipo;
        p->mec = mec;
		if(!ant){
			p->prox=L;
			L=p;
		}else{
			p->prox=ant->prox;
			ant->prox=p;
		}
	}
	return L;
}

// void main(){
//     PtNo L = NULL;
//     L = insere(L, 1, 2);
//     L = insere(L, 3, 4);
//     L = insere(L, 5, 6);
//     mostraLista(L);
// }