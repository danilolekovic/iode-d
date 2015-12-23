#pragma once
#include <llvm/IR/Value.h>
#include "ASTType.h"

using namespace llvm;

class Base
{
public:
	virtual ~Base() {}
	virtual Value *generate() = 0;
	virtual ASTType type() = 0;
};

