#pragma once
#include <iostream>
#include "TokenType.h"

using namespace std;

class Token
{
public:
	TokenType id; // token type
	string value; // value of the token
	Token(TokenType _id, string _value) :
		id(_id), value(_value) { }
};
