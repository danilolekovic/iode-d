DC := dmd
FILES := source/iode.d source/parsing/parser.d source/lexical/lexer.d source/lexical/token.d source/gen/codeGen.d source/gen/stash.d source/errors/astError.d source/errors/lexerError.d source/errors/parserError.d source/ast/node.d source/assets/variable.d

iode:
	$(DC) $(FILES)

clean:
	rm iode.o
	rm iode