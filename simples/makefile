compila:  lexico.l sintatico.y
		flex -o lexico.c lexico.l
		bison -v -d sintatico.y -o sintatico.c
		gcc mvs.c -o mvs
		gcc lista.c pilha.c tabela.c lexico.c sintatico.c -o simples	

limpa: 
		rm -f mvs lexico.c sintatico.c sintatico.output sintatico.h simples

mvs: sintatico.y
		./simples amostras/t1.simples
		cat amostras/t1.mvs

roda: 
	./mvs amostras/t6.mvs	

build3: 
	make compila
	./simples amostras/t3.simples
	colordiff amostras/t3.mvs referencias/t3.mvs

build4: 
	make compila
	./simples amostras/t4.simples
	colordiff amostras/t4.mvs referencias/t4.mvs

build5: 
	make compila
	./simples amostras/t5.simples
	colordiff amostras/t5.mvs referencias/t5.mvs

build6: 
	make compila
	./simples amostras/t6.simples
	colordiff amostras/t6.mvs referencias/t6.mvs

build7: 
	make compila
	./simples amostras/t7.simples
	colordiff amostras/t7.mvs referencias/t7.mvs

build8: 
	make compila
	./simples amostras/t8.simples
	colordiff amostras/t8.mvs referencias/t8.mvs

build9: 
	make compila
	./simples amostras/t9.simples
	colordiff amostras/t9.mvs referencias/t9.mvs

build10: 
	make compila
	./simples amostras/t10.simples
	colordiff amostras/t10.mvs referencias/t10.mvs


