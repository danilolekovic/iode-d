module main;

import std.stdio;
import iode.lexical.token;
import iode.lexical.lexer;

void main(string[] args) {
	Lexer lexer = new Lexer("\"Hello\"");
	lexer.tokenize();

	writeln(lexer.tokens[0].getType());
}
