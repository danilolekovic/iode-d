module iode.errors.astError;

import std.stdio;
import std.conv;
import iode.gen.stash;

class ASTException : Exception {
    this(string msg) {
        super(msg ~ " on line # " ~ to!string(Stash.line));
    }
}
