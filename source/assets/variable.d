module iode.assets.variable;

import std.stdio;
import llvm.c;
import iode.ast.node;

class Variable {
    public string type = null;
    public Node value = null;
    public LLVMValueRef llvmValue;

    this(string type, Node value) {
        this.type = type;
        this.value = value;
        this.llvmValue = value.generate();
    }

    this(string type, LLVMValueRef llvmValue) {
        this.type = type;
        this.llvmValue = llvmValue;
    }

    this(Node value) {
        this.value = value;
        this.llvmValue = value.generate();
    }

    this(LLVMValueRef llvmValue) {
        this.llvmValue = llvmValue;
    }
}
