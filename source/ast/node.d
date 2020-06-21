module iode.ast.node;

import std.stdio;
import std.string;
import std.conv;
import iode.gen.stash;
import iode.errors.astError;
import iode.assets.variable;

/* base class */
interface Node {
    public string nodeType();
    string generate();
}

/* representation of a number in the AST */
class NodeNumber : Node {
    public string nodeType() { return "Number"; }
    private ulong value;

    this(ulong value) {
        this.value = value;
    }

    string generate() {
        return to!string(value);
    }
}

/* representation of a double in the AST */
class NodeDouble : Node {
    public string nodeType() { return "Double"; }
    private double value;

    this(double value) {
        this.value = value;
    }

    string generate() {
        return to!string(value);
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

    string generate() {
        return left.generate() ~ op ~ right.generate();
    }
}

/* representation of a string in the AST */
class NodeString : Node {
    public string nodeType() { return "String"; }
    private string value;

    this(string value) {
        this.value = value;
    }

    string generate() {
        return "\"" ~ value ~ "\"";
    }
}

/* representation of a boolean in the AST */
class NodeBoolean : Node {
    public string nodeType() { return "Boolean"; }
    private bool value;

    this(bool value) {
        this.value = value;
    }

    string generate() {
        return value ? "true" : "false";
    }
}

/* representation of a null value in the AST */
class NodeNull : Node {
    public string nodeType() { return "Null"; }

    string generate() {
        return "null";
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

    string generate() {
        return name ~ " = " ~ value.generate();
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

    string generate() {
        return constant ? "const " ~ name ~ " = " ~ value.generate() : "var " ~ name ~ " = " ~ value.generate();
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
    string generate() {
        return constant ? "const " ~ name ~ " = " ~ value.generate() : "var " ~ name ~ " = " ~ value.generate();
    }
}

/* representation of a variable in the ast */
class NodeVariable : Node {
    public string nodeType() { return "Variable"; }
    private string name;

    this(string name) {
        this.name = name;
    }

    string generate() {
        return name;
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

    // todo
    string generate() {
        string sb = name ~ "(";

        foreach (i, Node n; args) {
            sb ~= n.generate();

            if (i != args.length - 1) {
                sb ~= ", ";
            }
        }

        sb ~= ")\n";

        return sb;
    }
}

/* representation of a return expression in the ast */
class NodeReturn : Node {
    public string nodeType() { return "Return"; }
    public Node value;

    this(Node value) {
        this.value = value;
    }

    string generate() {
        return "return " ~ value.generate();
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

    // todo
    string generate() {
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

    // todo
    string generate() {
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
            sb ~= "\t" ~ n.generate() ~ "\n";
        }

        sb ~= "}";

        return sb;
    }
}

/* representation of a newline in the AST */
class NodeNewline : Node {
    public string nodeType() { return "Newline"; }

    string generate() {
        return "\n";
    }
}
