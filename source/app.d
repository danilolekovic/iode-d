module iode.main;

import std.stdio;
import iode.gen.codeGen;

void main(string[] args) {
	CodeGenerator.run("fn main() > Int { return 0\n }");
}
