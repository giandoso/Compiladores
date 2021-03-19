compila:  lexico.l sintatico.y
		flex -o lexico.c lexico.l
		bison -v -d sintatico.y -o sintatico.c
		gcc mvs.c -o mvs
		gcc pilha.c tabela.c lexico.c sintatico.c -o simples	

limpa: 
		rm -f mvs lexico.c sintatico.c sintatico.output sintatico.h simples

mvs: sintatico.y
		./simples amostras/t2.simples
		cat amostras/t2.mvs


build: 
	make compila
	./simples amostras/t2.simples
	cat amostras/t2.mvs
	./mvs amostras/t2.mvs	
