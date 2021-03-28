compila:  lexico.l sintatico.y
		flex -o lexico.c lexico.l
		bison -v -d sintatico.y -o sintatico.c
		gcc mvs.c -o mvs
		gcc lista.c pilha.c tabela.c lexico.c sintatico.c -o simples	

limpa: 
		rm -f mvs lexico.c sintatico.c sintatico.output sintatico.h simples

mvs: sintatico.y
		./simples amostras/t6.simples
		cat amostras/t6.mvs

roda: 
	./mvs amostras/t6.mvs	
build: 
	make compila
	./simples amostras/t6.simples
	
