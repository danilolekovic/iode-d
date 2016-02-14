module iode.assets.variable;

import std.stdio;
import llvm.c;
import iode.ast.node;

class Variable {
    public bool constant = false;
    public string type = null;
    public Node value = null;
    public LLVMValueRef llvmValue;

    this(bool constant, string type, Node value) {
        this.constant = constant;
        this.type = type;
        this.value = value;
        this.llvmValue = value.generate();
    }

    this(bool constant, string type, LLVMValueRef llvmValue) {
        this.constant = constant;
        this.type = type;
        this.llvmValue = llvmValue;
    }

    this(bool constant, Node value) {
        this.constant = constant;
        this.value = value;
        this.llvmValue = value.generate();
    }

    this(bool constant, LLVMValueRef llvmValue) {
        this.constant = constant;
        this.llvmValue = llvmValue;
    }
}
