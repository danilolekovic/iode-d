module iode.main;

import std.stdio;
import iode.gen.codeGen;

void main(string[] args) {
	CodeGenerator.run("returnNumber(25)\n");
}
