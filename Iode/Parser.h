#pragma once
#include <string>
#include "Token.h"
#include "NumberNode.h"
#include "FunctionNode.h"
#include "Lexer.h"
#include "Base.h"

using namespace std;

// Turns tokens into an abstract syntax tree

class Parser
{
public:
	string code; // the input code
	int pos; // current position in the vector of tokens
	int line; // current line #
	int totalTokens; // total amount of tokens from the lexer
	Lexer lexer; // the lexer
	Token peekToken(); // looks ahead one token
	bool peekCheck(TokenType type); // checks if the next token is a <type>
	bool peekSpecificCheck(TokenType type, int i); // checks if a certain token is a <type>
	Token peekSpecific(int i); // looks ahead <i> token
	Token nextToken(); // returns next token
	void skipNewline(); // skips the upcoming newline
	NumberNode *parseNumber(); // [0-9]+
	FunctionNode *parseFunction(); // fn name(args..) { ... }
	Base *parseNext(); // parses the next expression

	Parser(Lexer _lexer) : lexer(_lexer), pos(0), line(1),
		totalTokens(lexer.tokens.size()), code(lexer.code) { }
};

