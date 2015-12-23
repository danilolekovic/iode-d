#include "stdafx.h"
#include "NumberNode.h"
#include <llvm/IR/IRBuilder.h>

using namespace llvm;

Value *NumberNode::generate()
{
	return ConstantFP::get(getGlobalContext(), APFloat(val));
}
