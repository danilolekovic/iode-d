module iode.assets.variable;

import std.stdio;

class Variable {
    public string type = null;
    public Node value;

    this(string type, Node value) {
        this.type = type;
        this.value = value;
    }

    this(Node value) {
        this.value = value;
    }
}
