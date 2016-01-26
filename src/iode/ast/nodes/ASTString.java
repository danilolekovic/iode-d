package iode.ast.nodes;

import iode.ast.Node;

public class ASTString extends Node {

	private String value;
	
	public ASTString(String value) {
		this.value = value;
	}

	@Override
	public String generate() {
		return "\"" + value + "\"";
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}
}
