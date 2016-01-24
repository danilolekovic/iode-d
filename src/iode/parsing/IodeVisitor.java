package iode.parsing;

import iode.ast.nodes.ASTBoolean;
import iode.ast.nodes.ASTCall;
import iode.ast.nodes.ASTDeclaration;
import iode.ast.nodes.ASTFunction;
import iode.ast.nodes.ASTImport;
import iode.ast.nodes.ASTNewline;
import iode.ast.nodes.ASTNumber;
import iode.ast.nodes.ASTReturn;
import iode.ast.nodes.ASTSetting;
import iode.ast.nodes.ASTString;
import iode.ast.nodes.ASTVariable;

public class IodeVisitor implements IVisitor {
	
	@Override
	public ASTBoolean Visit(ASTBoolean bool) {
		return bool;
	}
	
	@Override
	public ASTCall Visit(ASTCall call) {
		return call;
	}

	@Override
	public ASTDeclaration Visit(ASTDeclaration decl) {
		return decl;
	}

	@Override
	public ASTFunction Visit(ASTFunction func) {
		return func;
	}
	
	@Override
	public ASTImport Visit(ASTImport imp) {
		return imp;
	}
	
	@Override
	public ASTNewline Visit(ASTNewline nl) {
		return nl;
	}

	@Override
	public ASTNumber Visit(ASTNumber num) {
		return num;
	}
	
	@Override
	public ASTReturn Visit(ASTReturn ret) {
		return ret;
	}

	@Override
	public ASTSetting Visit(ASTSetting set) {
		return set;
	}

	@Override
	public ASTString Visit(ASTString str) {
		return str;
	}

	@Override
	public ASTVariable Visit(ASTVariable var) {
		return var;
	}
}
