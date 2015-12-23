#pragma once
#include <llvm/IR/Value.h>

using namespace llvm;

class Base
{
public:
	virtual ~Base() {}
	virtual Value *generate() = 0;
};

