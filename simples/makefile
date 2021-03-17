build: 
	make limpa
	make simples
	make testa

simples:  lexico.l sintatico.y
		flex -o lexico.c lexico.l
		bison -v -d sintatico.y -o sintatico.c
		gcc pilha.c lexico.c sintatico.c -o simples

limpa: 
		rm -f lexico.c sintatico.c sintatico.output sintatico.h simples

testa: 
		./simples < amostras/t1.simples
		./simples < amostras/comentario.simples
		./simples < amostras/enquanto.simples