package iode.ast.nodes;

import iode.ast.Node;
import iode.parsing.IVisitor;

public class ASTSetting extends Node {

	private String name;
	private Node value;

	public ASTSetting(String name, Node value) {
		this.name = name;
		this.value = value;
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}

	@Override
	public String generate() {
		// TODO Auto-generated method stub
		return null;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Node getValue() {
		return value;
	}

	public void setValue(Node value) {
		this.value = value;
	}
}
