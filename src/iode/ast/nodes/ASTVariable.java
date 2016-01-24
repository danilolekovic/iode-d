package iode.ast.nodes;

import iode.ast.Node;
import iode.parsing.IVisitor;

public class ASTVariable extends Node {

	private String ident;
	
	public ASTVariable(String ident) {
		this.ident = ident;
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}

	@Override
	public String generate() {
		return ident;
	}

	public String getValue() {
		return ident;
	}

	public void setValue(String ident) {
		this.ident = ident;
	}
}
