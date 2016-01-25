package iode.ast.nodes;

import iode.ast.Node;
import iode.parsing.IVisitor;

public class ASTNil extends Node {
	
	public ASTNil() {
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}

	@Override
	public String generate() {
		return "NULL";
	}
}
