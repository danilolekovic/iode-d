module iode.main;

import std.stdio;
import iode.gen.codeGen;

void main(string[] args) {
	CodeGenerator.run("var test = 5\n fn main() > Int { return test\n }");
}
