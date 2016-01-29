module iode.ast.node;

import llvm.c;

/* base class */
interface Node {
    LLVMValueRef generate();
}

/* representation of a number in the AST */
class NodeNumber : Node {
    private double value;

    this(double value) {
        this.value = value;
    }

    LLVMValueRef generate() {
        return LLVMConstReal(LLVMDoubleType(), value);
    }
}

/* representation of a boolean in the AST */
class NodeBoolean : Node {
    private bool value;

    this(bool value) {
        this.value = value;
    }

    LLVMValueRef generate() {
        if (value) {
            return LLVMConstReal(LLVMInt16Type(), 1);
        } else {
            return LLVMConstReal(LLVMInt16Type(), 0);
        }
    }
}

/* representation of a variable declaration in the AST */
class NodeDeclaration : Node {
    private string name;
    private Node value;

    this(string name, Node value) {
        this.name = name;
        this.value = value;
    }

    LLVMValueRef generate() {
        // TODO: do this
        return value.generate();
    }
}
