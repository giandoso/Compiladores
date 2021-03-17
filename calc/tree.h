typedef struct no *ptno;

struct no{
    int tipo, valor;
    ptno filho, irmao;
};

ptno criaNo(int, int);
void adicionaFilho(ptno, ptno);
void mostra(ptno, int);