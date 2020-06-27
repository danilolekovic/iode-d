module iode.gen.codeGen;

import std.stdio;
import std.string;
import iode.lexical.token;
import iode.lexical.lexer;
import iode.parsing.parser;
import iode.ast.node;
import iode.gen.stash;

class CodeGenerator {
    public static void run(string code) {
        Lexer lexer = new Lexer(code);
    	lexer.tokenize();

    	Parser parser = new Parser(lexer);
    	Node[] ast;

        // todo: replace this
    	while (parser.pos != parser.totalTokens) {
    		ast ~= parser.start();
    	}

		string builder = "";

		foreach (Node n; ast) {
			builder ~= n.generate() ~ "\n";
		}

		// create js compiled file
    }
}
