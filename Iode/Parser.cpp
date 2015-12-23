#include "stdafx.h"
#include "Parser.h"
#include "ErrorFactory.h"

// for more information, see Parser.h

Token Parser::peekToken()
{
	return lexer.peekToken();
}

bool Parser::peekCheck(TokenType type)
{
	return peekToken().id == type;
}

bool Parser::peekSpecificCheck(TokenType type, int i)
{
	return peekSpecific(i).id == type;
}

Token Parser::peekSpecific(int i)
{
	return lexer.peekSpecific(i);
}

Token Parser::nextToken()
{
	pos++;

	if (peekCheck(NEWLINE))
	{
		line++;
	}

	return lexer.nextToken();
}

void Parser::skipNewline()
{
	while (peekCheck(NEWLINE))
	{
		nextToken();
	}
}

// Nodes

NumberNode *Parser::parseNumber()
{
	NumberNode *nn = new NumberNode(stod(nextToken().value));
	skipNewline();
	return nn;
}

FunctionNode *Parser::parseFunction()
{
	nextToken();
	skipNewline();

	if (peekCheck(IDENTIFIER))
	{
		string name = nextToken().value;
		skipNewline();

		if (peekCheck(LPAREN))
		{
			nextToken();
			skipNewline();
			vector<string> args;

			while (!peekCheck(RPAREN))
			{
				if (peekCheck(IDENTIFIER))
				{
					args.push_back(nextToken().value);
					skipNewline();

					if (peekCheck(COMMA))
					{
						nextToken();
						skipNewline();
					}
					else if (peekCheck(RPAREN))
					{
						nextToken();
						skipNewline();
						break;
					}
					else
					{
						error("Expected a comma", line);
					}
				}
				else
				{
					error("Expected an identifier", line);
				}
			}

			if (peekCheck(LBRACE))
			{
				vector<Base> body;
				nextToken();
				skipNewline();

				while (!peekCheck(RBRACE))
				{
					Base *next = parseNext();
					body.push_back(*next);
					skipNewline();

					if (peekCheck(NEWLINE))
					{
						nextToken();
						skipNewline();
					}
					else if (peekCheck(RBRACE))
					{
						nextToken();
						skipNewline();
						break;
					}
					else
					{
						error("Expected a '}'", line);
					}
				}

				return new FunctionNode(name, args, body);
			}
			else
			{
				error("Expected a '{'", line);
			}
		}
		else
		{
			error("Expected a '('", line);
		}

		return NULL;
	}
	else
	{
		error("Expected an identifier", line);
	}
}

// Gets the next node, whatever it may be
Base *Parser::parseNext()
{
	Token tok = peekToken();

	if (tok.id == NUMBER)
	{
		return parseNumber();
	}
	else if (tok.id == FUNCTION)
	{
		return parseFunction();
	}
	else
	{
		error("Illegal token: " + tok.value, line);
	}
}