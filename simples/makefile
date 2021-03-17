build: 
	make limpa
	make compila
	make mvs
	make roda

compila:  lexico.l sintatico.y
		flex -o lexico.c lexico.l
		bison -v -d sintatico.y -o sintatico.c
		gcc mvs.c -o mvs
		gcc pilha.c tabela.c lexico.c sintatico.c -o simples

limpa: 
		rm -f mvs lexico.c sintatico.c sintatico.output sintatico.h simples

mvs: 
		./simples < amostras/t2.simples > t2.mvs
		cat t2.mvs

roda: 
		./mvs t2.mvs	
