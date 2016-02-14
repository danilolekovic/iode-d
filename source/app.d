module iode.main;

import std.stdio;
import iode.gen.codeGen;

void main(string[] args) {
	CodeGenerator.run("fn main() > Int { let const = 2; return 0; }");
}
