package iode.ast.nodes;

import java.util.ArrayList;

import iode.ast.Node;
import iode.parsing.IVisitor;

public class ASTEnum extends Node {

	private String name;
	private ArrayList<Node> args;
	
	public ASTEnum(String name, ArrayList<Node> args) {
		this.name = name;
		this.args = args;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public ArrayList<Node> getArgs() {
		return args;
	}

	public void setArgs(ArrayList<Node> args) {
		this.args = args;
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}
	
	@Override
	public String generate() {
		StringBuilder sb = new StringBuilder();
		sb.append("enum ");
		sb.append(name);
		sb.append(" {");
		
		if (!args.isEmpty()) {
			for (Node n : args) {
				sb.append(n.generate());
				sb.append(", ");
			}
			
			sb.setLength(sb.length() - 2);
		}
		
		sb.append("};\n");
		
		return sb.toString();
	}
}
