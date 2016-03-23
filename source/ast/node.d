module iode.ast.node;

import std.stdio;
import std.string;
import llvm.c;
import iode.gen.stash;
import iode.errors.astError;
import iode.assets.variable;

/* base class */
interface Node {
    public string nodeType();
    LLVMValueRef generate();
}

/* representation of a number in the AST */
class NodeNumber : Node {
    public string nodeType() { return "Number"; }
    private ulong value;

    this(ulong value) {
        this.value = value;
    }

    LLVMValueRef generate() {
        return LLVMConstInt(LLVMInt32Type(), value, false);
    }
}

/* representation of a mathematical operation in the AST */
class NodeBinaryOp : Node {
    public string nodeType() { return "Binary Operation"; }
    private Node left;
    private string op;
    private Node right;

    this(Node left, string op, Node right) {
        this.left = left;
        this.op = op;
        this.right = right;
    }

    LLVMValueRef generate() {
        LLVMValueRef l = left.generate();
        LLVMValueRef r = right.generate();
        LLVMValueRef ret = null;

        if (op == "+") {
            ret = LLVMBuildAdd(Stash.builder, l, r, "addtmp");
        } else if (op == "-") {
            ret = LLVMBuildSub(Stash.builder, l, r, "subtmp");
        } else if (op == "*") {
            ret = LLVMBuildMul(Stash.builder, l, r, "multmp");
        } else if (op == "/") {
            ret = LLVMBuildUDiv(Stash.builder, l, r, "divtmp");
        } else {
            throw new ASTException("Illegal operator: " ~ op);
        }

        return ret;
    }
}

/* representation of a string in the AST */
class NodeString : Node {
    public string nodeType() { return "String"; }
    private string value;

    this(string value) {
        this.value = value;
    }

    LLVMValueRef generate() {
        // TODO: fix this!!! somehow!
        return LLVMBuildGlobalString(Stash.builder, value.toStringz(), "str".toStringz());
    }
}

/* representation of a boolean in the AST */
class NodeBoolean : Node {
    public string nodeType() { return "Boolean"; }
    private bool value;

    this(bool value) {
        this.value = value;
    }

    LLVMValueRef generate() {
        if (value) {
            return LLVMConstReal(LLVMInt1Type(), 1);
        } else {
            return LLVMConstReal(LLVMInt1Type(), 0);
        }
    }
}

/* representation of a null value in the AST */
class NodeNull : Node {
    public string nodeType() { return "Null"; }

    LLVMValueRef generate() {
        return LLVMConstNull(LLVMVoidType());
    }
}

/* representation of a variable setting in the AST */
class NodeSetting : Node {
    public string nodeType() { return "Setting"; }
    public string name;
    private Node value;

    this(string name, Node value) {
        this.name = name;
        this.value = value;
    }

    LLVMValueRef generate() {
        Stash.setVariable(name, value);
        return null;
    }
}

/* representation of a variable declaration in the AST */
class NodeDeclaration : Node {
    public string nodeType() { return "Declaration"; }
    public bool constant;
    public string name;
    private Node value;

    this(bool constant, string name, Node value) {
        this.constant = constant;
        this.name = name;
        this.value = value;
    }

    LLVMValueRef generate() {
        Stash.newVariable(constant, name, value);
        return null;
    }
}

/* representation of a typed variable declaration in the AST */
class NodeTypedDeclaration : Node {
    public string nodeType() { return "Typed Declaration"; }
    public bool constant;
    public string name;
    private string type;
    private Node value;

    this(bool constant, string name, string type, Node value) {
        this.constant = constant;
        this.name = name;
        this.type = type;
        this.value = value;
    }

    LLVMValueRef generate() {
        // TODO: variables.

        LLVMValueRef realValue = value.generate();

        if (type == "Int" && value.nodeType() == "Number" ||
            type == "String" && value.nodeType() == "String" ||
            type == "Bool" && value.nodeType() == "Boolean" ||
            type == "Null" && value.nodeType() == "Null") {

            Stash.newVariable(constant, type, name, realValue);
        } else {
            throw new ASTException("Expected type of " ~ type ~ ", got " ~ value.nodeType());
        }

        return null;
    }
}

/* representation of a variable in the ast */
class NodeVariable : Node {
    public string nodeType() { return "Variable"; }
    private string name;

    this(string name) {
        this.name = name;
    }

    LLVMValueRef generate() {
        if (Stash.checkVariable(name)) {
            return Stash.getVariable(name).llvmValue;
        } else {
            throw new ASTException("Variable '" ~ name ~ "' does not exist");
        }
    }
}

/* representation of a function call in the ast */
class NodeCall : Node {
    public string nodeType() { return "Call"; }
    private string name;
    private Node[] args;

    this(string name, Node[] args) {
        this.name = name;
        this.args = args;
    }

    LLVMValueRef generate() {
        LLVMValueRef caller = LLVMGetNamedFunction(Stash.theModule, name.toStringz());

        if (caller == null) {
            throw new ASTException("Unknown function: " ~ name);
        }

        if (LLVMCountParams(caller) != args.length) {
            throw new ASTException("Function '" ~ name ~ "' expected "
                ~ to!string(LLVMCountParams(caller)) ~ " params but got "
                ~ to!string(args.length) ~ " params");
        }

        LLVMValueRef[] generated;

        foreach (arg; args) {
            generated ~= arg.generate();
        }

        uint len = to!uint(generated.length);

        NodeExtern* p = (name in Stash.externs);

        if (p !is null) {
            if (Stash.externs[name].type == "Void") {
                return LLVMBuildCall(Stash.builder, caller, generated.ptr, len, "");
            } else {
                return LLVMBuildCall(Stash.builder, caller, generated.ptr, len, "calltmp");
            }
        } else {
            if (Stash.funcs[name].type == "Void") {
                return LLVMBuildCall(Stash.builder, caller, generated.ptr, len, "");
            } else {
                return LLVMBuildCall(Stash.builder, caller, generated.ptr, len, "calltmp");
            }
        }
    }
}

/* representation of a return expression in the ast */
class NodeReturn : Node {
    public string nodeType() { return "Return"; }
    public Node value;

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

/* representation of an external function declaration in ast */
class NodeExtern : Node {
    public string nodeType() { return "External"; }
    private string type;
    private string name;
    private string[] argTypes;

    this(string type, string name, string[] argTypes) {
        this.type = type;
        this.name = name;
        this.argTypes = argTypes;
    }

    LLVMValueRef generate() {
        LLVMTypeRef[] types;

        foreach (string s; argTypes) {
            if (s == "Int") {
                types ~= LLVMInt32Type();
            } else if (s == "String") {
                types ~= LLVMInt8Type();
            } else if (s == "Bool") {
                types ~= LLVMInt1Type();
            } else {
                throw new ASTException("Unknown argument type in extern: " ~ name);
            }
        }

        LLVMTypeRef retType;

        if (type == "Int") {
            retType = LLVMInt32Type();
        } else if (type == "String") {
            retType = LLVMInt8Type();
        } else if (type == "Bool") {
            retType = LLVMInt1Type();
        } else if (type == "Void") {
            retType = LLVMVoidType();
        } else {
            throw new ASTException("Unknown type: " ~ type);
        }

        auto funcType = LLVMFunctionType(retType, types.ptr, cast(uint)argTypes.length, 0);
        LLVMValueRef func = LLVMAddFunction(Stash.theModule, name.toStringz(), funcType);
        Stash.externs[name] = this;

        return func;
    }
}

/* representation of a function definition in the ast */
class NodeFunction : Node {
    public string nodeType() { return "Function"; }
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
                types ~= LLVMInt32Type();
            } else if (arg.type == "String") {
                types ~= LLVMInt8Type();
            } else if (arg.type == "Bool") {
                types ~= LLVMInt1Type();
            } else {
                throw new ASTException("Unknown type: " ~ arg.type);
            }
		}

        LLVMTypeRef theType;

        if (type == "Int") {
            theType = LLVMInt32Type();
        } else if (type == "String") {
            theType = LLVMInt8Type();
        } else if (type == "Bool") {
            theType = LLVMInt1Type();
        } else if (type == "Void") {
            theType = LLVMVoidType();
        } else {
            throw new ASTException("Unknown type: " ~ type);
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
            LLVMTypeRef t;

            if (args[index].type == "Int") {
                t = LLVMInt32Type();
            } else if (args[index].type == "String") {
                t = LLVMInt8Type();
            } else if (args[index].type == "Bool") {
                t = LLVMInt1Type();
            } else {
                throw new ASTException("Unknown type: " ~ args[index].type);
            }

        	auto alloca = LLVMBuildAlloca(Stash.builder, t, args[index].name.toStringz());
            LLVMPositionBuilderAtEnd(Stash.builder, backupCurrentBlock);

			LLVMBuildStore(Stash.builder, arg, alloca);
			Stash.newVariable(false, args[index].name, alloca);
		}

        string[] localVariables;
        bool hasReturn = false;

        foreach (expr; block) {
			if (cast(NodeDeclaration) expr) {
                NodeDeclaration decl = cast(NodeDeclaration) expr;
                localVariables ~= decl.name;
            }

            if (type != "Void") {
                if (cast(NodeReturn) expr) {
                    NodeReturn ret = cast(NodeReturn) expr;
                    
                    if (type == "Int" && ret.value.nodeType() == "Number" ||
                        type == "String" && ret.value.nodeType() == "String" ||
                        type == "Bool" && ret.value.nodeType() == "Boolean" ||
                        type == "Null" && ret.value.nodeType() == "Null" ||
                        type == "Int" && ret.value.nodeType() == "Binary Operation" ||
                        ret.value.nodeType() == "Variable") { // fix this

                        // good
                    } else {
                        throw new ASTException("Function '" ~ name ~ "' has an invalid return type");
                    }

                    hasReturn = true;
                }
            }

            expr.generate();
        }

        if (!hasReturn) {
            throw new ASTException("Function '" ~ name ~ "' does not have return value");
        }

        if (type == "Void") {
            LLVMBuildRetVoid(Stash.builder);
        }

        LLVMVerifyFunction(func, 1);
        LLVMRunFunctionPassManager(Stash.passManager, func);

        foreach (arg; args) {
			Stash.removeVariable(arg.name);
		}

        foreach (vari; localVariables) {
            Stash.removeVariable(vari);
        }

        Stash.funcs[name] = this;

        return func;
    }
}
