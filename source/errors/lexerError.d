module iode.errors.lexerError;

import std.stdio;
import std.conv;

class LexerException : Exception {
    this(string msg, int line) {
        super(msg ~ " on line # " ~ to!string(line) ~ ".");
    }
}
