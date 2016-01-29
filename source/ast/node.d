module iode.ast.node;

import std.stdio;
import std.string;
import llvm.c;
import iode.gen.stash;

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

/* representation of a string in the AST */
class NodeString : Node {
    private string value;

    this(string value) {
        this.value = value;
    }

    LLVMValueRef generate() {
        return LLVMConstString(value.toStringz(), to!uint(value.length), false);
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
        Stash.newVariable(name, value.generate());
        return null;
    }
}

/* representation of a variable in the ast */
class NodeVariable : Node {
    private string name;

    this(string name) {
        this.name = name;
    }

    LLVMValueRef generate() {
        if (Stash.checkVariable(name)) {
            return Stash.getVariable(name);
        } else {
            throw new Exception("Variable '" ~ name ~ "' does not exist");
        }
    }
}

/* representation of a function call in the ast */
class NodeCall : Node {
    private string name;
    private Node[] args;

    this(string name, Node[] args) {
        this.name = name;
        this.args = args;
    }

    LLVMValueRef generate() {
        LLVMValueRef caller = LLVMGetNamedFunction(Stash.theModule, name.toStringz());

        if (caller is null) {
            throw new Exception("Unknown function: " ~ name);
        }

        if (LLVMCountParams(caller) != args.length) {
            throw new Exception("Function '" ~ name ~ "' expected "
                ~ to!string(LLVMCountParams(caller)) ~ " params but got "
                ~ to!string(args.length) ~ " params.");
        }

        LLVMValueRef[] generated;

        foreach (arg; args) {
            generated ~= arg.generate();
        }

        uint len = to!uint(generated.length);

        return LLVMBuildCall(Stash.builder, caller, generated.ptr, len, "calltmp");
    }
}
