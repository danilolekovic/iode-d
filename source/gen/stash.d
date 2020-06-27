module iode.gen.stash;

import std.stdio;
import std.string;
import iode.errors.error;
import iode.assets.variable;
import iode.ast.node;

class Stash {
    public static Variable[string] namedValues;
    public static NodeFunction[string] funcs;
    public static NodeExtern[string] externs;
    public static int line = 1;
    public static string currentFile;
    public static string currentCode;

    public static Variable getVariable(string name) {
        if (checkVariable(name)) {
            return namedValues[name];
        } else {
            new IodeError("Variable " ~ name ~ " doesn't exist", line, "Error", true).call();
            return null;
        }
    }

    public static void newVariable(bool constant, string name, Node value) {
        if (!checkVariable(name)) {
            namedValues[name] = new Variable(constant, name, value);

            if (value.nodeType() == "Number") {
                namedValues[name].type = "Int";
            } else if (value.nodeType() == "String") {
                namedValues[name].type = "String";
            } else if (value.nodeType() == "Boolean") {
                namedValues[name].type = "Bool";
            } else if (value.nodeType() == "Null") {
                namedValues[name].type = "Null";
            }
        } else {
            new IodeError("Variable " ~ name ~ " already exists", line, "Error", true).call();
        }
    }

    public static void setVariable(string name, Node value) {
        if (checkVariable(name)) {
            if (namedValues[name].constant) {
                new IodeError("Variable " ~ name ~ " is constant and cannot be changed. Try removing the constant declaration.", line, "Error", true).call();
            }

            if (namedValues[name].type != null) {
                if (namedValues[name].type == "Int" && value.nodeType() == "Number" ||
                    namedValues[name].type == "String" && value.nodeType() == "String" ||
                    namedValues[name].type == "Bool" && value.nodeType() == "Boolean" ||
                    namedValues[name].type == "Null" && value.nodeType() == "Null") {

                } else {
                    new IodeError("Variable " ~ name ~ " can't be reinitialized as a " ~ value.nodeType(), line, "Error", true).call();
                }
            } else {
                if (namedValues[name].value.nodeType() == "Number") {
                    namedValues[name].type = "Int";
                } else if (namedValues[name].value.nodeType() == "String") {
                    namedValues[name].type = "String";
                } else if (namedValues[name].value.nodeType() == "Boolean") {
                    namedValues[name].type = "Bool";
                } else if (namedValues[name].value.nodeType() == "Null") {
                    namedValues[name].type = "Null";
                }

                if (namedValues[name].type == "Int" && value.nodeType() == "Number" ||
                    namedValues[name].type == "String" && value.nodeType() == "String" ||
                    namedValues[name].type == "Bool" && value.nodeType() == "Boolean" ||
                    namedValues[name].type == "Null" && value.nodeType() == "Null") {

                } else {
                    new IodeError("Variable " ~ name ~ " can't be reinitialized as a " ~ value.nodeType(), line, "Error", true).call();
                }
            }

            namedValues[name] = new Variable(false, name, value);
        } else {
            new IodeError("Variable " ~ name ~ " doesn't exist", line, "Error", true).call();
        }
    }

    public static void removeVariable(string name) {
        if (checkVariable(name)) {
            namedValues.remove(name);
        } else {
            new IodeError("Variable " ~ name ~ " doesn't exist", line, "Error", true).call();
        }
    }

    public static bool checkVariable(string name) {
        if (name in namedValues) {
            return true;
        } else {
            return false;
        }
    }
}
