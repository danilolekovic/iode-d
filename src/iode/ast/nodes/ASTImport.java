package iode.ast.nodes;

import iode.ast.Node;
import iode.parsing.IVisitor;

public class ASTImport extends Node {

	private String module;
	
	public ASTImport(String module) {
		this.module = module;
	}

	@Override
	public Node visit(IVisitor visitor) {
		return visitor.Visit(this);
	}

	@Override
	public String generate() {
		return "#include <" + module + ".h>\n";
	}

	public String getModule() {
		return module;
	}

	public void setModule(String module) {
		this.module = module;
	}
}
