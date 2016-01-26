package iode.ast.nodes;

import iode.ast.Node;

public class ASTSetting extends Node {

	private String name;
	private Node value;

	public ASTSetting(String name, Node value) {
		this.name = name;
		this.value = value;
	}

	@Override
	public String generate() {
		return name + " = " + value.generate() + ";\n";
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
