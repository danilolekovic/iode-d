package iode.ast.nodes;

import iode.ast.Node;

public class ASTParenthesis extends Node {

	private Node value;
	
	public ASTParenthesis(Node value) {
		this.value = value;
	}

	@Override
	public String generate() {
		return "(" + value.generate() + ")";
	}

	public Node getValue() {
		return value;
	}

	public void setValue(Node value) {
		this.value = value;
	}
}
