module iode.main;

import std.stdio;
import std.file;
import std.string;
import core.stdc.stdlib;
import iode.gen.codeGen;

void main(string[] args) {
	string[] files;
	bool help = false;
	bool compile = false;

	foreach (string arg; args) {
		if (arg == "-c" || arg == "--compile") {
			compile = true;
		} else if (arg == "-h" || arg == "--help") {
			help = true;
		} else {
			files ~= arg;
		}
	}

	removeAt(files, 0);

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
					CodeGenerator.run(code);
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

static void removeAt(T)(ref T[] arr, size_t index)
{
    foreach (i, ref item; arr[index .. $ - 1])
        item = arr[i + 1];
    arr = arr[0 .. $ - 1];
    arr.assumeSafeAppend();
}
