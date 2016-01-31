module iode.main;

import std.stdio;
import iode.gen.codeGen;

void main(string[] args) {
	CodeGenerator.run("fn test() > Void {} fn main() > Int { test(); return 0; }");
}
