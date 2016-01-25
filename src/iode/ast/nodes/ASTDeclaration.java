package iode.ast.nodes;

import iode.ast.Node;
import iode.parsing.IVisitor;

public class ASTDeclaration extends Node {

	private String name;
	private Node value;

	public ASTDeclaration(String name, Node value) {
		this.name = name;
		this.value = value;
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}

	@Override
	public String generate() {
		StringBuilder sb = new StringBuilder();
				
		if (value instanceof ASTBoolean) {
			sb.append("typedef enum { false, true } bool;\n");
			sb.append("bool ");
			sb.append(name);
		} else if (value instanceof ASTNumber) {
			sb.append("int ");
			sb.append(name);
		} else if (value instanceof ASTString) {
			sb.append("char *");
			sb.append(name);
			ASTString valStr = (ASTString) value;
		}
		
		sb.append(" = ");
		sb.append(value.generate());
		sb.append(";\n");
		
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
