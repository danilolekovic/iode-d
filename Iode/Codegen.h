#pragma once
#include "stdafx.h"
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>

using namespace llvm;

static Module *IodeModule = new Module("Iode", getGlobalContext());
static IRBuilder<> IodeBuilder(getGlobalContext());