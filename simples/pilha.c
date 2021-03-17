#define TAM_PIL 100
int msg(char*);

int Pilha[TAM_PIL];
int topo = -1;

void empilha(int n){
    if(topo == TAM_PIL){
        msg("pilha cheia");
    }
    Pilha[++topo] = n;
}

int desempilha(){
    if(topo == -1){
        msg("pilha vazia");
    }
    return Pilha[topo--];
}