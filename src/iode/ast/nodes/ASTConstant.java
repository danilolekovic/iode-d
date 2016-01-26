package iode.ast.nodes;

import iode.ast.Node;

public class ASTConstant extends Node {

	private String name;
	private Node value;

	public ASTConstant(String name, Node value) {
		this.name = name;
		this.value = value;
	}

	@Override
	public String generate() {
		StringBuilder sb = new StringBuilder();
				
		sb.append("#DEFINE ");
		sb.append(name);
		sb.append(" ");
		sb.append(value.generate());
		sb.append("\n");
		
		return sb.toString();
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
