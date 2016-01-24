package iode.ast;

import iode.parsing.IVisitor;

public abstract class Node  {
	public abstract Node visit(IVisitor visitor);
	public abstract String generate();
}
