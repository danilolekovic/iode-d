module iode.errors.parserError;

import std.stdio;
import std.conv;

class ParserException : Exception {
    this(string msg, int line) {
        super(msg ~ " on line # " ~ to!string(line));
    }
}
