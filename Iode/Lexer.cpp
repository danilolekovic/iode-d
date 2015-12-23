#include "stdafx.h"
#include "Lexer.h"

// for more information, see Lexer.h

Token Lexer::peekToken()
{
	return tokens[index + 1];
}

Token Lexer::peekSpecific(int i)
{
	return tokens[index + i];
}

Token Lexer::nextToken()
{
	index++;
	return tokens[index];
}

void Lexer::tokenize()
{
	int pos = 0;

	// while there still is code..
	while (pos < code.length())
	{
		string str = ""; // buffer for values

		// checking for literals
		if (isalpha(code[pos])) // checks if char is a letter
		{
			str += code[pos]; // append char to buffer
			pos++; // move on to the next char

			while (isalnum(code[pos])) // now we're checking if the char is a letter OR digit
			{
				str += code[pos];
				pos++;
			}

			// checking for keywords; if not a special keyword, it is an identifier
			if (str == "var")
			{
				tokens.push_back(Token(VAR, str)); // push to tokens vector
			}
			else if (str == "fn")
			{
				tokens.push_back(Token(FUNCTION, str));
			}

			// checking for bools and nil values
			else if (str == "true" || str == "false")
			{
				tokens.push_back(Token(BOOL, str));
			}
			else if (str == "nil")
			{
				tokens.push_back(Token(NIL, str));
			}

			// must be an identifier
			else
			{
				tokens.push_back(Token(IDENTIFIER, str));
			}

			str = ""; // reset buffer
		}
		else if (isdigit(code[pos])) // checks if char is a number
		{
			str += code[pos];
			pos++;

			while (isdigit(code[pos]))
			{
				str += code[pos];
				pos++;
			}

			tokens.push_back(Token(NUMBER, str));

			str = "";
		}

		// checking for whitespace, newlines, etc.
		else if (isspace(code[pos]))
		{
			// ignore whitespace
			pos++;
		}
		else if (code[pos] == '\n')
		{
			line++;
			pos++;
			tokens.push_back(Token(NEWLINE, "\n"));
		}

		// checking for operators, symbols, etc.
		else if (code[pos] == '+')
		{
			pos++;
			tokens.push_back(Token(ADD, "+"));
		}
		else if (code[pos] == '-')
		{
			pos++;
			tokens.push_back(Token(SUB, "-"));
		}
		else if (code[pos] == '*')
		{
			pos++;
			tokens.push_back(Token(MUL, "*"));
		}
		else if (code[pos] == '/')
		{
			pos++;
			tokens.push_back(Token(DIV, "/"));
		}
		else if (code[pos] == '=')
		{
			pos++;
			tokens.push_back(Token(EQUALS, "="));
		}
		else if (code[pos] == '.')
		{
			pos++;
			tokens.push_back(Token(DOT, "."));
		}
		else if (code[pos] == ',')
		{
			pos++;
			tokens.push_back(Token(COMMA, ","));
		}
		else if (code[pos] == '(')
		{
			pos++;
			tokens.push_back(Token(LPAREN, "("));
		}
		else if (code[pos] == ')')
		{
			pos++;
			tokens.push_back(Token(RPAREN, ")"));
		}
		else if (code[pos] == '{')
		{
			pos++;
			tokens.push_back(Token(LBRACE, "{"));
		}
		else if (code[pos] == '}')
		{
			pos++;
			tokens.push_back(Token(RBRACE, "}"));
		}
	}
}