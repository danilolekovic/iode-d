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
    public string type;
    public bool breaking;

    this(string message, int line, string type, bool breaking) {
        this.message = message;
        this.line = line;
        this.type = type;
        this.breaking = breaking;
    }

    public void call() {
        // width is 80 by default so lets just assume this until we figure out how to determine the terminal 

        string header = color("Error", fg.red);

        if (type == "Warning") {
            header = color(type, fg.yellow);
        } else if (type == "Suggestion") {
            header = color(type, fg.green);
        }

        string bars = "";

        for (int i = 1; i <= 75 - header.length - Stash.currentFile.length; i++) {
            bars ~= "-";
        }

        string title = color("-- ", fg.cyan) ~ header ~ " " ~ color(bars, fg.cyan) ~ " " ~ color(Stash.currentFile, fg.cyan);
        
        writeln(title);
        writeln();
        writeln("\t" ~ color(" " ~ to!string(line - 3) ~ " ", fg.light_black, bg.white) ~ " " ~ Stash.currentCode.split('\n')[line - 4]);
        writeln();
        writeln(color("Iode> ", fg.cyan) ~ message);

        if (breaking) {
            exit(0);
        }
    }
}