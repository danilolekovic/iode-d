#pragma once
#include "Base.h"
#include <string>
#include <vector>

using namespace std;

class FunctionNode : public Base
{
	string name; // name of the function
	vector<string> args; // arguments
	vector<Base*> *body; // block

public:
	FunctionNode(string _name, vector<string> _args, vector<Base*> *_body)
		: name(_name), args(_args), body(_body) { }
	virtual Value *generate() override;
	virtual ASTType type() override;
};

