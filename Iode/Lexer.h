#pragma once
#include <iostream>
#include <ctype.h>
#include "Token.h"
#include <vector>

using namespace std;

// Consumes raw code, outputs tokens that the parser can understand.

class Lexer
{
public:
	string code; // the input code
	int index; // current position in the code
	int line; // current line number
	vector<Token> tokens; // lexer ouput
	Token peekToken(); // looks ahead one token
	Token peekSpecific(int i); // looks ahead <i> token
	Token nextToken(); // eats next token
	void tokenize(); // generates tokens

	Lexer(string program) : code(program)
	{
		// defaults
		index = -1;
		line = 1;
	}
};
