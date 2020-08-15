module iode.ast.node;

import std.stdio;
import std.string;
import std.conv;
import iode.gen.stash;
import iode.errors.error;
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
        return name ~ " = " ~ value.generate() ~ ";";
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
        return constant ? "const " ~ name ~ " = " ~ value.generate() : "var " ~ name ~ " = " ~ value.generate() ~ ";";
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
        return constant ? "const " ~ name ~ " = " ~ value.generate() ~ ";" : "var " ~ name ~ " = " ~ value.generate() ~ ";";
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
    private int line;

    this(string name, Node[] args, int line) {
        this.name = name;
        this.args = args;
        this.line = line;
    }

    // todo
    string generate() {
        string sb = "(";

        foreach (i, Node n; args) {
            sb ~= n.generate();

            if (i != args.length - 1) {
                sb ~= ", ";
            }
        }

        sb ~= ");";

        // check for attributes

        if (name in Stash.funcs) {
            if (Stash.funcs[name].attribute == "deprecated") {
                new IodeError("Function deprecated", line, "Warning", false).call();
            }
        }

        if (name == "puts") {
            sb = "console.log" ~ sb;
        } else {
            sb = name ~ sb;
        }

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
        return "return " ~ value.generate() ~ ";";
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

class NodeAttribute : Node {
    public string nodeType() { return "Attribute"; }
    private string attribute;

    this(string attribute) {
        this.attribute = attribute;
    }

    string generate() {
        // set attribute in stash
        return "/* ATTRIBUTE: " ~ attribute ~ " */\n";
    }
}

/* representation of a function definition in the ast */
class NodeFunction : Node {
    public string nodeType() { return "Function"; }
    private string attribute;
    private string name;
    private Arg[] args;
    private string type;
    private Node[] block;

    this(string attribute, string name, Arg[] args, string type, Node[] block) {
        this.attribute = attribute;
        this.name = name;
        this.args = args;
        this.type = type;
        this.block = block;
    }

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

        // double check that there aren't same names being redeclared
        Stash.funcs[name] = this;

        return sb;
    }
}

/* representation of a class definition in the ast */
class NodeClass : Node {
    public string nodeType() { return "Class"; }
    private string attribute;
    private string name;
    private Node[] block;

    this(string attribute, string name, Node[] block) {
        this.attribute = attribute;
        this.name = name;
        this.block = block;
    }

    string generate() {
        string sb = "class " ~ name ~ " {";

        foreach (Node n; block) {
            sb ~= "\t" ~ n.generate() ~ "\n";
        }

        sb ~= "}";


        // add to class stash
        //Stash.funcs[name] = this;

        return sb;
    }
}

/* representation of a newline in the AST */
class NodeNewline : Node {
    public string nodeType() { return "Newline"; }

    string generate() {
        Stash.line++;
        return "\n";
    }
}
