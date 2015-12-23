// Iode.cpp : Defines the entry point for the console application.

#include "stdafx.h"
#include <iostream>
#include <string>
#include "Lexer.h"
#include "Parser.h"
#include "Codegen.h"

using namespace std;
using namespace llvm;

int main()
{
	string code = "123";

	Lexer lex = Lexer(code);
	lex.tokenize();

	Parser parser = Parser(lex);
	Base *first = parser.parseNext();

	cout << first->generate() << endl;

	cin.get();
	return 0;
}

