#pragma once
#include <llvm/IR/Value.h>
#include "Base.h"

class NumberNode : public Base
{
	double val;

public:
	NumberNode(double _val) : val(_val) { }
	Value *generate() override;
};

