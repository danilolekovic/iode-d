// Iode.cpp : Defines the entry point for the console application.

#include "stdafx.h"
#include <iostream>
#include <string>
#include <llvm/IR/GlobalValue.h>
#include "Codegen.h"
#include "Lexer.h"
#include "Parser.h"

using namespace std;
using namespace llvm;

void generateCode(string code)
{
	vector<const Type*> argTypes;
	FunctionType *ftype = FunctionType::get(Type::getVoidTy(getGlobalContext()), false);
	Function *mainFunction = Function::Create(ftype, GlobalValue::InternalLinkage, "main", IodeModule);
	BasicBlock *bblock = BasicBlock::Create(getGlobalContext(), "entry", mainFunction, 0);

	Lexer lex = Lexer(code);
	lex.tokenize();

	Parser parser = Parser(lex);
	vector<Base*> *statements{};

	while (parser.pos < parser.totalTokens)
	{
		statements->push_back(parser.parseNext());
	}

	for (Base* b : *statements)
	{

		cout << "Parsed: " << b->type() << endl;
		b->generate();
	}

	ReturnInst::Create(getGlobalContext(), bblock);
}

int main()
{
	string code = "123";
	generateCode(code);

	cin.get();
	return 0;
}

