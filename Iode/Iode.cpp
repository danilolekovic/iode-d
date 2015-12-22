// Iode.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"
#include <iostream>
#include <string>
#include "Lexer.h"

using namespace std;

int main()
{
	Lexer lexer = Lexer("var i = 5 + 5");
	lexer.tokenize();

	for (Token t : lexer.tokens)
	{
		cout << t.value << endl;
	}

	cin.get();

	return 0;
}

