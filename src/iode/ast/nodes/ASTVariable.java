package iode.ast.nodes;

import iode.ast.Node;

public class ASTVariable extends Node {

	private String ident;
	
	public ASTVariable(String ident) {
		this.ident = ident;
	}

	@Override
	public String generate() {
		return ident;
	}

	public String getValue() {
		return ident;
	}

	public void setValue(String ident) {
		this.ident = ident;
	}
}
