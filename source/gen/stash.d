module iode.gen.stash;

import std.stdio;
import std.string;
import llvm.c;
import iode.errors.astError;
import iode.assets.variable;
import iode.ast.node;

class Stash {
    public static Variable[string] namedValues;
    public static LLVMTypeRef[string] funcTypes;
    public static LLVMModuleRef theModule;
    public static LLVMBuilderRef builder;
    public static LLVMPassManagerRef passManager;
    public static LLVMExecutionEngineRef engine;
    public static int line = 1;

    public static Variable getVariable(string name) {
        if (checkVariable(name)) {
            return namedValues[name];
        } else {
            throw new ASTException("Variable " ~ name ~ " doesn't exist");
        }
    }

    public static void newVariable(bool constant, string name, Node value) {
        if (!checkVariable(name)) {
            namedValues[name] = new Variable(constant, value);
        } else {
            throw new ASTException("Variable " ~ name ~ " already exists");
        }
    }

    public static void newVariable(bool constant, string name, LLVMValueRef value) {
        if (!checkVariable(name)) {
            namedValues[name] = new Variable(constant, value);
        } else {
            throw new ASTException("Variable " ~ name ~ " already exists");
        }
    }

    public static void newVariable(bool constant, string type, string name, LLVMValueRef value) {
        if (!checkVariable(name)) {
            namedValues[name] = new Variable(constant, type, value);
        } else {
            throw new ASTException("Variable " ~ name ~ " already exists");
        }
    }

    public static void setVariable(string name, Node value) {
        if (checkVariable(name)) {
            if (namedValues[name].constant) {
                throw new ASTException("Variable " ~ name ~ " is constant and cannot be changed");
            }

            namedValues[name] = new Variable(false, value);
        } else {
            throw new ASTException("Variable " ~ name ~ " doesn't exists");
        }
    }

    public static void removeVariable(string name) {
        if (checkVariable(name)) {
            if (namedValues[name].constant) {
                throw new ASTException("Variable " ~ name ~ " is constant and cannot be removed");
            }

            namedValues.remove(name);
        } else {
            throw new ASTException("Variable " ~ name ~ " doesn't exist");
        }
    }

    public static bool checkVariable(string name) {
        if (name in namedValues) {
            return true;
        } else {
            return false;
        }
    }

    public static LLVMValueRef addPuts() {
        LLVMTypeRef[] types = [LLVMPointerType(LLVMInt8Type(), LLVMGetPointerAddressSpace(LLVMInt8Type()))];
        LLVMTypeRef theType = LLVMInt32Type();

        auto funcType = LLVMFunctionType(theType, types.ptr, cast(uint)types.length, false);
		LLVMValueRef func = LLVMAddFunction(theModule, "puts".toStringz(), funcType);

        return func;
    }
}
