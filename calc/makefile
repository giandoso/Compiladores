calc :  calc.l calc.y
		flex -o lex.c calc.l
		bison -v -d calc.y -o calc.c
		gcc tree.c lex.c calc.c -o calc

limpa : 
		rm -f lex.c calc.c calc.output calc.dot calc.h calc