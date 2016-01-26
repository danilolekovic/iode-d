package iode.ast.nodes;

import iode.ast.Node;

public class ASTNumber extends Node {

	private int value;
	
	public ASTNumber(int value) {
		this.value = value;
	}

	@Override
	public String generate() {
		return getValue() + "";
	}

	public int getValue() {
		return value;
	}

	public void setValue(int value) {
		this.value = value;
	}
}
