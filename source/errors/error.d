module iode.errors.error;

import std.stdio;
import std.array;
import std.conv;
import core.stdc.stdlib : exit;
import iode.gen.stash;
import colorize;

class IodeError {
    public string message;
    public int line;
    public int col;
    public string type;
    public bool breaking;

    this(string message, int line, int col, string type, bool breaking) {
        this.message = message;
        this.line = line;
        this.col = col;
        this.type = type;
        this.breaking = breaking;
    }

    public void call() {
        writeln(color(Stash.currentFile, fg.black, bg.white) ~ " " ~ color(type, fg.yellow));
        writeln();
        writeln(color(" " ~ to!string(line - 3) ~ " ", fg.light_black, bg.white) ~ " " ~ Stash.currentCode.split('\n')[line - 4]);
        writeln();
        writeln(color("Iode> ", fg.cyan) ~ message);

        if (breaking) {
            exit(0);
        }
    }
}