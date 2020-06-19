module iode.assets.variable;

import std.stdio;
import iode.ast.node;

class Variable {
    public bool constant = false;
    public string type = null;
    public Node value = null;

    this(bool constant, string type, Node value) {
        this.constant = constant;
        this.type = type;
        this.value = value;
    }
}
