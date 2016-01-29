module main;

import std.stdio;
import iode.lexical.token;
import iode.lexical.lexer;
import iode.parsing.parser;
import iode.ast.node;

void main(string[] args) {
	Lexer lexer = new Lexer("var a = 2\n");
	lexer.tokenize();

	Parser parser = new Parser(lexer);
	Node[] ast;

	while (parser.pos != parser.totalTokens) {
		ast ~= parser.start();
	}

	foreach (n; ast) {
		writeln(n);
	}

	writeln("Done");
}
