#pragma once
#include "Base.h"
#include <llvm/IR/Value.h>

class NumberNode : public Base
{
	double val;

public:
	NumberNode(double _val) : val(_val) {}
	Value *generate() override;
};

