package iode.ast.nodes;

import iode.ast.Node;
import iode.parsing.IVisitor;

public class ASTBoolean extends Node {

	private boolean value;
	
	public ASTBoolean(boolean value) {
		this.value = value;
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}

	@Override
	public String generate() {
		if (value) {
			return "1";
		} else {
			return "0";
		}
	}

	public boolean getValue() {
		return value;
	}

	public void setValue(boolean value) {
		this.value = value;
	}
}
