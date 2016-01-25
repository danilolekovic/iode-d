package iode.ast.nodes;

import iode.ast.Node;
import iode.parsing.IVisitor;

public class ASTNewline extends Node {

	public ASTNewline() {
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}

	@Override
	public String generate() {
		return "";
	}
}
