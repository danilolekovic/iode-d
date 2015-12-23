#include "stdafx.h"
#include <llvm/IR/IRBuilder.h>
#include "NumberNode.h"

using namespace llvm;

Value *NumberNode::generate()
{
	return ConstantFP::get(getGlobalContext(), APFloat(val));
}

ASTType NumberNode::type()
{
	return AST_NUMBER;
}
