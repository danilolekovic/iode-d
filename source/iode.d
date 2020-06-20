module iode.main;

import std.stdio;
import std.file;
import std.string;
import std.datetime;
import std.datetime.stopwatch : benchmark, StopWatch;
import std.conv;
import core.stdc.stdlib;
import iode.gen.codeGen;

void main(string[] args) {
	string[] files;
	bool help = false;
	bool vrsn = false;

	foreach (string arg; args) {
		if (arg == "-h" || arg == "--help") {
			help = true;
		} else if (arg == "-v" || arg == "--version") {
			vrsn = true;
		} else {
			files ~= arg;
		}
	}

	if (help) {
		getHelp();
	}

	if (vrsn) {
		getVersion();
	}

	if (!help && !vrsn && files.length <= 1) {
		getHelp();
		exit(0);
	}

	if (files.length > 0) {
		removeAt(files, 0);
	}

	foreach (string filePath; files) {
		if (exists(filePath) != 0) {
			if (endsWith(filePath, ".iode")) {
				auto f = File(filePath);
			    scope(exit) f.close();
				string code = "";

			    foreach (str; f.byLine) {
					code ~= str;
					code ~= "\n";
				}

				if (code != "") {
					StopWatch sw;
					sw.start();
					CodeGenerator.run(code);
					sw.stop();
					long msecs = sw.peek.total!"msecs";
					writeln("Execution: " ~ to!string(msecs) ~ "ms");
				}
			} else {
				writeln("File is not an .iode file.");
				exit(-1);
			}
		} else {
		  writeln("File not found.");
		  exit(-1);
		}
	}
}

void getHelp() {
	writeln();
	writeln("The Iode Programming Language");
	writeln();
	writeln("Usage: iode <options> [files]");
	writeln();
	writeln("Options:");
	writeln("\t-v, --version         returns Iode version");
	writeln("\t-h, --help            returns usage info");
	writeln();
	writeln("Examples:");
	writeln("\tiode -v");
	writeln("\tiode test.iode test2.iode tests/test3.iode");
	writeln();
}

void getVersion() {
	writeln();
	writeln("Iode v1.0.0");
	writeln();
}

static void removeAt(T)(ref T[] arr, size_t index) {
    foreach (i, ref item; arr[index .. $ - 1]) {
        item = arr[i + 1];
	}

    arr = arr[0 .. $ - 1];
    arr.assumeSafeAppend();
}
