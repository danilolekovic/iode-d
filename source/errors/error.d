module iode.errors.error;

import std.stdio;
import std.array;
import std.conv;
import iode.gen.stash;
import colorize;

class IodeError {
    public string message;
    public int line;
    public int col;
    public string fileName;
    public string type;

    this(string message, int line, int col, string type) {
        this.message = message;
        this.line = line;
        this.col = col;
        this.fileName = "NONE";
        this.type = type;
    }

    this(string message, int line, int col, string fileName, string type) {
        this.message = message;
        this.line = line;
        this.col = col;
        this.fileName = fileName;
        this.type = type;
    }

    public void call() {
        writeln(color(fileName, fg.black, bg.white) ~ " " ~ color(type, fg.yellow));
        writeln();
        writeln(color(" 1 ", fg.light_black, bg.white) ~ " " ~ Stash.currentCode.split('\n')[0]);
        writeln();
        writeln(color("Iode> ", fg.cyan) ~ message);
    }
}