module iode.gen.stash;

import std.stdio;
import std.string;
import llvm.c;

class Stash {
    public static LLVMValueRef[string] namedValues;
    public static LLVMModuleRef theModule;
    public static LLVMBuilderRef builder;
    public static LLVMPassManagerRef passManager;
    public static LLVMExecutionEngineRef engine;

    this(LLVMModuleRef theModule, LLVMBuilderRef builder) {
        this.theModule = theModule;
        this.builder = builder;
    }

    public static LLVMValueRef getVariable(string name) {
        if (checkVariable(name)) {
            return namedValues[name];
        } else {
            throw new Exception("Variable " ~ name ~ " doesn't exist.");
        }
    }

    public static void newVariable(string name, LLVMValueRef value) {
        if (!checkVariable(name)) {
            namedValues[name] = value;
        } else {
            throw new Exception("Variable " ~ name ~ " already exists.");
        }
    }

    public static void setVariable(string name, LLVMValueRef value) {
        if (checkVariable(name)) {
            namedValues[name] = value;
        } else {
            throw new Exception("Variable " ~ name ~ " doesn't exists.");
        }
    }

    public static void removeVariable(string name) {
        if (checkVariable(name)) {
            namedValues.remove(name);
        } else {
            throw new Exception("Variable " ~ name ~ " doesn't exist.");
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
        LLVMTypeRef[] types = [LLVMInt8Type()];
        LLVMTypeRef theType = LLVMInt32Type();

        auto funcType = LLVMFunctionType(theType, types.ptr, cast(uint)types.length, false);
		LLVMValueRef func = LLVMAddFunction(theModule, "puts".toStringz(), funcType);

        return func;
    }
}
