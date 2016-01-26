package iode.ast.nodes;

import iode.ast.Node;

public class ASTReturn extends Node {

	private Node expression;
	
	public ASTReturn(Node expression) {
		this.expression = expression;
	}

	@Override
	public String generate() {
		return "return " + expression.generate() + ";";
	}

	public Node getExpression() {
		return expression;
	}

	public void setExpression(Node expression) {
		this.expression = expression;
	}
}
