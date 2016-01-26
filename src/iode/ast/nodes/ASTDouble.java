package iode.ast.nodes;

import iode.ast.Node;

public class ASTDouble extends Node {

	private double value;
	
	public ASTDouble(double value) {
		this.value = value;
	}

	@Override
	public String generate() {
		return getValue() + "";
	}

	public double getValue() {
		return value;
	}

	public void setValue(double value) {
		this.value = value;
	}
}
