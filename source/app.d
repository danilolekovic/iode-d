module iode.main;

import std.stdio;
import iode.gen.codeGen;

void main(string[] args) {
	CodeGenerator.run("fn main() > Int { var a = 2; a = \"Test\"; return 0; }");
}
