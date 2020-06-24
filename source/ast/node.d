module iode.ast.node;

import std.stdio;
import std.string;
import std.conv;
import iode.gen.stash;
import iode.errors.astError;
import iode.assets.variable;
import iode.gen.codeGen;
import llvm;

/* base class */
interface Node {
    public string nodeType();
    string generateJS();
    LLVMValueRef generate();
}

/* representation of a number in the AST */
class NodeNumber : Node {
    public string nodeType() { return "Number"; }
    private ulong value;

    this(ulong value) {
        this.value = value;
    }

    string generateJS() {
        return to!string(value);
    }

    LLVMValueRef generate() {
        return LLVMConstInt(LLVMInt32Type(), value, false);
    }
}

/* representation of a double in the AST */
class NodeDouble : Node {
    public string nodeType() { return "Double"; }
    private double value;

    this(double value) {
        this.value = value;
    }

    string generateJS() {
        return to!string(value);
    }

    LLVMValueRef generate() {
        return LLVMConstReal(LLVMDoubleType(), value);
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

    string generateJS() {
        return left.generateJS() ~ op ~ right.generateJS();
    }

    LLVMValueRef generate() {
        LLVMValueRef l = left.generate();
        LLVMValueRef r = right.generate();
        LLVMValueRef ret = null;

        if (op == "+") {
            ret = LLVMBuildAdd(CodeGenerator.builder, l, r, "addtmp");
        } else if (op == "-") {
            ret = LLVMBuildSub(CodeGenerator.builder, l, r, "subtmp");
        } else if (op == "*") {
            ret = LLVMBuildMul(CodeGenerator.builder, l, r, "multmp");
        } else if (op == "/") {
            ret = LLVMBuildUDiv(CodeGenerator.builder, l, r, "divtmp");
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

    string generateJS() {
        return "\"" ~ value ~ "\"";
    }

    LLVMValueRef generate() {
        LLVMValueRef glob = LLVMAddGlobal(CodeGenerator.mod, LLVMArrayType(LLVMInt8Type(), to!uint(value.length)), "string");

        // set as internal linkage and constant
        LLVMSetLinkage(glob, LLVMInternalLinkage);
        LLVMSetGlobalConstant(glob, true);

        // Initialize with string:
        LLVMSetInitializer(glob, LLVMConstString(value.toStringz(), to!uint(value.length), true));

        return glob;
    }
}

/* representation of a boolean in the AST */
class NodeBoolean : Node {
    public string nodeType() { return "Boolean"; }
    private bool value;

    this(bool value) {
        this.value = value;
    }

    string generateJS() {
        return value ? "true" : "false";
    }

    LLVMValueRef generate() {
        return value ? LLVMConstReal(LLVMInt1Type(), 1) : LLVMConstReal(LLVMInt1Type(), 0);
    }
}

/* representation of a null value in the AST */
class NodeNull : Node {
    public string nodeType() { return "Null"; }

    string generateJS() {
        return "null";
    }

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

    string generateJS() {
        return name ~ " = " ~ value.generateJS();
    }

    // todo
    LLVMValueRef generate() {
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

    string generateJS() {
        return constant ? "const " ~ name ~ " = " ~ value.generateJS() : "var " ~ name ~ " = " ~ value.generateJS();
    }

    // todo
    LLVMValueRef generate() {
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

    // TODO: handle types. question: do we want types?
    string generateJS() {
        return constant ? "const " ~ name ~ " = " ~ value.generateJS() : "var " ~ name ~ " = " ~ value.generateJS();
    }

    // todo
    LLVMValueRef generate() {
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

    string generateJS() {
        return name;
    }

    // todo
    LLVMValueRef generate() {
        return null;
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

    string generateJS() {
        string sb = name ~ "(";

        foreach (i, Node n; args) {
            sb ~= n.generateJS();

            if (i != args.length - 1) {
                sb ~= ", ";
            }
        }

        sb ~= ")\n";

        return sb;
    }

    // todo
    LLVMValueRef generate() {
        return null;
    }
}

/* representation of a return expression in the ast */
class NodeReturn : Node {
    public string nodeType() { return "Return"; }
    public Node value;

    this(Node value) {
        this.value = value;
    }

    string generateJS() {
        return "return " ~ value.generateJS();
    }

    LLVMValueRef generate() {
        return LLVMBuildRet(CodeGenerator.builder, value.generate());
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

    string generateJS() {
        return null;
    }

    // todo
    LLVMValueRef generate() {
        return null;
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

    string generateJS() {
        string sb = "let " ~ name ~ " = function(";

        if (args.length > 0) {
            foreach (Arg n; args) {
                sb ~= n.name ~ ", ";
            }

            sb = chop(sb) ~ ") {";
        } else {
            sb ~= ") {";
        }

        foreach (Node n; block) {
            sb ~= "\t" ~ n.generateJS() ~ "\n";
        }

        sb ~= "}";

        return sb;
    }

    // todo
    LLVMValueRef generate() {
        LLVMTypeRef[] types;

		foreach (arg; args) {
			if (arg.type == "Int") {
                types ~= LLVMInt32Type();
			} else if (arg.type == "Double") {
                types ~= LLVMDoubleType();
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
        } else if (type == "Double") {
            theType = LLVMDoubleType();
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

		LLVMValueRef func = LLVMAddFunction(CodeGenerator.mod, name.toStringz(), funcType);

		LLVMValueRef[] params;
		params.length = LLVMCountParams(func);
		LLVMGetParams(func, params.ptr);

		foreach (index, arg; params) {
            const(char)* argName = toStringz(args[index].name);
			LLVMSetValueName2(arg, argName, to!uint(args[index].name.length));
		}

        LLVMBasicBlockRef basicBlock = LLVMAppendBasicBlock(func, "entry");
		LLVMPositionBuilderAtEnd(CodeGenerator.builder, basicBlock);

        LLVMValueRef[] prms;
		prms.length = LLVMCountParams(func);
		LLVMGetParams(func, prms.ptr);

		foreach (index, arg; prms) {
            auto backupCurrentBlock = LLVMGetInsertBlock(CodeGenerator.builder);
        	LLVMPositionBuilderAtEnd(CodeGenerator.builder, LLVMGetFirstBasicBlock(func));
            LLVMTypeRef t;

            if (args[index].type == "Int") {
                t = LLVMInt32Type();
            } else if (args[index].type == "Double") {
                t = LLVMDoubleType();
            } else if (args[index].type == "String") {
                t = LLVMInt8Type();
            } else if (args[index].type == "Bool") {
                t = LLVMInt1Type();
            } else {
                throw new ASTException("Unknown type: " ~ args[index].type);
            }

        	auto alloca = LLVMBuildAlloca(CodeGenerator.builder, t, args[index].name.toStringz());
            LLVMPositionBuilderAtEnd(CodeGenerator.builder, backupCurrentBlock);

			LLVMBuildStore(CodeGenerator.builder, arg, alloca);
		}

        if (type == "Void") {
            LLVMBuildRetVoid(CodeGenerator.builder);
        }

        LLVMVerifyFunction(func, 1);
        LLVMRunFunctionPassManager(CodeGenerator.passManager, func);

        CodeGenerator.funcs[name] = this;

        return func;
    }
}

/* representation of a newline in the AST */
class NodeNewline : Node {
    public string nodeType() { return "Newline"; }

    string generateJS() {
        return "\n";
    }

    // todo
    LLVMValueRef generate() {
        return null;
    }
}
