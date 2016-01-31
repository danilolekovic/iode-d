module iode.errors.parserError;

import std.stdio;
import std.conv;
import iode.gen.stash;

class ParserException : Exception {
    this(string msg) {
        super(msg ~ " on line #" ~ to!string(Stash.line) ~ ".");
    }
}
