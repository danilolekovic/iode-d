package iode.ast.nodes;

import iode.ast.Node;
import iode.parsing.IVisitor;

public class ASTString extends Node {

	private String value;
	
	public ASTString(String value) {
		this.value = value;
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
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
