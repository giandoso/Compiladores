/*+−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−
| UNIFAL − Universidade Federal de Alfenas
| BACHARELADO EM CIÊNCIAS DA COMPUTAÇÃO  
| Trabalho . . . : Compilador Simples − Funcao
| Disciplina  . .: Teoria de Linguagens e Compiladores
| Professor .  . : Luiz Eduardo da Silva
| Aluno . . . .. : João Pedro Giandoso
| Data . .  .. . : 30/03/2021
+−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−−*/
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

int simbolo_existe(char *id, char escopo){
    // puts("Simbolo_existe");
    // printf("> %30s | %c\n", id, escopo);
    int i = 0;
    for(i = 0; i <= pos_tab; i++){
        // printf("%d %30s | %c\n", i, TabSimb[i].id, TabSimb[i].escopo);
        if(TabSimb[i].escopo == escopo && strcmp(TabSimb[i].id, id) == 0){
            return 1;
        }
    }
    return 0;
}

int busca_simbolo(char *id, char escopo){
    //puts("Busca_simbolo");
    //printf("> %30s | %c\n", id, escopo);
    // int i = pos_tab -1;
    //maiuscula(id);
    // for(; strcmp(TabSimb[i].id, id) && i>=0; i--);
    // return i;
    int i = 0;
    for(i = 0; i <= pos_tab; i++){
        //printf("%d %30s | %c\n", i, TabSimb[i].id, TabSimb[i].escopo);
        if((TabSimb[i].escopo == escopo && strcmp(TabSimb[i].id, id) == 0) ||
           (TabSimb[i].cat == 'F' && strcmp(TabSimb[i].id, id) == 0)){
            return i;
        }
    }
    return -1;   
}

int busca_hash(int endereco){
    int i = 0;
    for(i = 0; i <= pos_tab; i++){
        if(TabSimb[i].endereco == endereco){
            printf("busca hash: %s",TabSimb[i].id);
            return i; 
        }
    }
}

void insere_simbolo(struct elem_tab_simbolos elem){
    // int i = pos_tab -1;
    if(pos_tab == TAM_TAB){
        msg("OVERFLOW");
    }

    if(simbolo_existe(elem.id, elem.escopo)){
        msg("Identificador duplicado");
    }
    //maiuscula(elem.id);
    TabSimb[pos_tab] = elem;
    pos_tab++;
}

void mostra_lista(PtNo L){
	printf("[ ");
	while(L){
        char tipo[4] = "";
        L->tipo == 1 ? strcpy(tipo, "INT") : strcpy(tipo, "LOG"); 
        char mec[4] = "";
        L->mec == 10 ? strcpy(mec, "VAL") : strcpy(mec, "REF");
		printf("{%s | %s}", tipo, mec);
		L=L->prox;
		if(L){
			printf(" -> ");
		}	
	}
		printf(" ]");
}

void mostra_tabela(){
    int i = 0;
    int ligado = 1; // ligar debug aqui, mudando para 1
    if(ligado == 1){
        printf("\n%3s |%30s | %s | %s | %s | %s | %s | %s | %s | %s", "  #", "ID", "END", "TIP", "MEC", "ROT", "ESC", "CAT", "NPAR", "LPAR");
        for(i = 0; i < pos_tab ; i++){


            printf("\n%3d |%30s | %3d | %3d | %3d | %3d | %3c | %3c | %3d  | ",TabSimb[i].hash, TabSimb[i].id, TabSimb[i].endereco, TabSimb[i].tipo, TabSimb[i].mecanismo, TabSimb[i].rotulo, TabSimb[i].escopo, TabSimb[i].cat, TabSimb[i].npar);
            if(TabSimb[i].listapar != NULL){
                mostra_lista(TabSimb[i].listapar);
            }
        }
        printf("\n\n");
    }
}

int popula_deslocamento(PtNo lista){
    int i = pos_tab - 1;
    int start = -3;
    int npar = 0;
    while(TabSimb[i].cat != 'F'){
        TabSimb[i].endereco = start;
        start--;
        i--;
        npar++;
    }
    TabSimb[i].endereco = start;
    TabSimb[i].npar = npar;
    TabSimb[i].listapar = lista;
    mostra_tabela();
    return npar;
}

void remove_variaveis_locais(int npar, int nvar){
    pos_tab -= npar;
    pos_tab -= nvar;
    mostra_tabela();
}

