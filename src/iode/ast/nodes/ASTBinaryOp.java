package iode.ast.nodes;

import iode.ast.Node;

public class ASTBinaryOp extends Node {
	
	private Node left;
	private String op;
	private Node right;
	
	public ASTBinaryOp(Node left, String op, Node right) {
		this.left = left;
		this.op = op;
		this.right = right;
	}

	@Override
	public String generate() {
		if (left instanceof ASTString || right instanceof ASTString) {
			return "combine(" + left.generate() + ", " + right.generate() + ")";
		}
		
		return left.generate() + " " + op + " " + right.generate();
	}

	public Node getLeft() {
		return left;
	}

	public void setLeft(Node left) {
		this.left = left;
	}

	public String getOp() {
		return op;
	}

	public void setOp(String op) {
		this.op = op;
	}

	public Node getRight() {
		return right;
	}

	public void setRight(Node right) {
		this.right = right;
	}
}
