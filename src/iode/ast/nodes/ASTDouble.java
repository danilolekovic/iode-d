package iode.ast.nodes;

import iode.ast.Node;
import iode.parsing.IVisitor;

public class ASTDouble extends Node {

	private double value;
	
	public ASTDouble(double value) {
		this.value = value;
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}

	@Override
	public String generate() {
		return getValue() + "";
	}

	public double getValue() {
		return value;
	}

	public void setValue(double value) {
		this.value = value;
	}
}
