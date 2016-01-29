module iode.gen.stash;

import std.stdio;
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
        namedValues[name] = value;
    }

    public static bool checkVariable(string name) {
        if (name in namedValues) {
            return true;
        } else {
            return false;
        }
    }
}
