package iode.ast.nodes;

import iode.ast.Node;
import iode.parsing.IVisitor;
import iode.util.Errors;

public class ASTDeclaration extends Node {

	private String name;
	private String type;
	private Node value;

	public ASTDeclaration(String name, String type, Node value) {
		this.name = name;
		this.type = type;
		this.value = value;
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}

	@Override
	public String generate() {
		StringBuilder sb = new StringBuilder();
				
		if (type.equals("Bool")) {
			sb.append("typedef enum { false, true } bool;\n");
			sb.append("bool ");
			sb.append(name);
		} else if (type.equals("Int")) {
			sb.append("int ");
			sb.append(name);
		} else if (type.equals("Double")) {
			sb.append("double ");
			sb.append(name);
		} else if (type.equals("Char")) {
			sb.append("char ");
			sb.append(name);
		} else if (type.equals("String")) {
			sb.append("char *");
			sb.append(name);
		} else if (value != null && value instanceof ASTArray) {
			if (type.equals("Bool")) {
				sb.append("typedef enum { false, true } bool;\n");
				sb.append("bool ");
				sb.append(name);
			} else if (type.equals("Int")) {
				sb.append("int ");
				sb.append(name);
			} else if (type.equals("String")) {
				sb.append("char *");
				sb.append(name);
			}
			
			sb.append("[]");
		} else {
			Errors.throwException(new Exception("'" + type + "' is not a valid object type"));
		}
		
		if (value != null) {
			sb.append(" = ");
			sb.append(value.generate());
		}
		
		sb.append(";\n");
		
		return sb.toString();
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Node getValue() {
		return value;
	}

	public void setValue(Node value) {
		this.value = value;
	}
}
