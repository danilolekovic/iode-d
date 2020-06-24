DC := dmd
FILES := source/iode.d source/parsing/parser.d source/lexical/lexer.d source/lexical/token.d source/gen/codeGen.d source/gen/stash.d source/errors/astError.d source/errors/lexerError.d source/errors/parserError.d source/ast/node.d source/assets/variable.d -I./.dub/packages/llvm-d-3.0.0/llvm-d/source

iode:
	$(DC) $(FILES)

clean:
	rm iode.o
	rm iode
	rm libiode.a