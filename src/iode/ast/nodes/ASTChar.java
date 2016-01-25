package iode.ast.nodes;

import iode.ast.Node;
import iode.parsing.IVisitor;

public class ASTChar extends Node {

	private char value;
	
	public ASTChar(char value) {
		this.value = value;
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}

	@Override
	public String generate() {
		return "'" + value + "'";
	}

	public char getValue() {
		return value;
	}

	public void setValue(char value) {
		this.value = value;
	}
}
