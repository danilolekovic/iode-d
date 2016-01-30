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

/* representation of a null value in the AST */
class NodeNull : Node {
    LLVMValueRef generate() {
        return LLVMConstNull(LLVMVoidType());
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

/* representation of a return expression in the ast */
class NodeReturn : Node {
    private Node value;

    this(Node value) {
        this.value = value;
    }

    LLVMValueRef generate() {
        return LLVMBuildRet(Stash.builder, value.generate());
    }
}

/* helper class for functions */
class Arg {
    public string type;
    public string name;

    this(string type, string name) {
        this.type = type;
        this.name = name;
    }
}

/* representation of a function definition in the ast */
class NodeFunction : Node {
    private string name;
    private Arg[] args;
    private string type;
    private Node[] block;

    this(string name, Arg[] args, string type, Node[] block) {
        this.name = name;
        this.args = args;
        this.type = type;
        this.block = block;
    }

    LLVMValueRef generate() {
        LLVMTypeRef[] types;

		foreach (arg; args) {
			if (arg.type == "Int") {
                types ~= LLVMDoubleType();
            } else if (arg.type == "String") {
                // TODO: string type
                types ~= LLVMDoubleType();
            } else if (arg.type == "Bool") {
                types ~= LLVMInt16Type();
            } else {
                types ~= LLVMVoidType();
            }
		}

        LLVMTypeRef theType;

        if (type == "Int") {
            theType = LLVMDoubleType();
        } else if (type == "String") {
            // TODO: string type
            theType = LLVMDoubleType();
        } else if (type == "Bool") {
            theType = LLVMInt16Type();
        } else if (type == "Void") {
            theType = LLVMVoidType();
        } else {
            theType = LLVMVoidType();
        }

        auto funcType = LLVMFunctionType(theType, types.ptr, cast(uint)types.length, false);

		LLVMValueRef func = LLVMAddFunction(Stash.theModule, name.toStringz(), funcType);

		LLVMValueRef[] params;
		params.length = LLVMCountParams(func);
		LLVMGetParams(func, params.ptr);

		foreach (index, arg; params) {
			LLVMSetValueName(arg, args[index].name.toStringz());
		}

        LLVMBasicBlockRef basicBlock = LLVMAppendBasicBlock(func, "entry");
		LLVMPositionBuilderAtEnd(Stash.builder, basicBlock);

        LLVMValueRef[] prms;
		prms.length = LLVMCountParams(func);
		LLVMGetParams(func, prms.ptr);

		foreach (index, arg; prms) {
            auto backupCurrentBlock = LLVMGetInsertBlock(Stash.builder);
        	LLVMPositionBuilderAtEnd(Stash.builder, LLVMGetFirstBasicBlock(func));
        	auto alloca = LLVMBuildAlloca(Stash.builder, LLVMDoubleType(), args[index].name.toStringz());
            LLVMPositionBuilderAtEnd(Stash.builder, backupCurrentBlock);

			LLVMBuildStore(Stash.builder, arg, alloca);
			Stash.newVariable(args[index].name, alloca);
		}

        foreach (expr; block) {
			LLVMBuildRet(Stash.builder, expr.generate());
        }

        LLVMVerifyFunction(func, 1);
        LLVMRunFunctionPassManager(Stash.passManager, func);

        return func;
    }
}
