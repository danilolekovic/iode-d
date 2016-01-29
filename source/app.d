module main;

import std.stdio;
import iode.lexical.token;
import iode.lexical.lexer;
import iode.ast.node;

void main(string[] args) {
	Lexer lexer = new Lexer("+");
	lexer.tokenize();

	writeln(lexer.tokens[0].getType());
}
