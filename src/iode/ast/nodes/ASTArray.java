package iode.ast.nodes;

import java.util.ArrayList;

import iode.ast.Node;

public class ASTArray extends Node {

	private ArrayList<Node> value;
	
	public ASTArray(ArrayList<Node> value) {
		this.value = value;
	}

	@Override
	public String generate() {
		StringBuilder sb = new StringBuilder();
		sb.append("{ ");
		
		for (Node n : value) {
			sb.append(n.generate());
			sb.append(", ");
		}
		
		sb.setLength(sb.length() - 2);
		sb.append(" }");
		
		return sb.toString();
	}

	public ArrayList<Node> getValue() {
		return value;
	}

	public void setValue(ArrayList<Node> value) {
		this.value = value;
	}
}
