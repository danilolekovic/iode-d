#pragma once
#include "stdafx.h"
#include <llvm/IR/IRBuilder.h>
#include <llvm/IR/LLVMContext.h>
#include <llvm/IR/Module.h>

using namespace llvm;

static std::unique_ptr<Module> IodeModule = make_unique<Module>("Iode", getGlobalContext());
static IRBuilder<> IodeBuilder(getGlobalContext());
static map<string, Value*> Variables;