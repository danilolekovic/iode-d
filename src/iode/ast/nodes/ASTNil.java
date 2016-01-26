package iode.ast.nodes;

import iode.ast.Node;

public class ASTNil extends Node {
	
	public ASTNil() {
	}

	@Override
	public String generate() {
		return "NULL";
	}
}
