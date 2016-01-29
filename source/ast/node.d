module iode.ast.node;

import llvm.c;

interface Node {
    LLVMValueRef generate();
}

class NodeNumber : Node {
    private double value;

    this(double value) {
        this.value = value;
    }

    LLVMValueRef generate() {
        return LLVMConstReal(LLVMDoubleType(), value);
    }
}
