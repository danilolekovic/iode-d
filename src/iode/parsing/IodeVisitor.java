package iode.parsing;

import iode.ast.nodes.ASTArray;
import iode.ast.nodes.ASTBoolean;
import iode.ast.nodes.ASTCall;
import iode.ast.nodes.ASTChar;
import iode.ast.nodes.ASTConstant;
import iode.ast.nodes.ASTDeclaration;
import iode.ast.nodes.ASTDouble;
import iode.ast.nodes.ASTEnum;
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
	public ASTArray Visit(ASTArray arr) {
		return arr;
	}
	
	@Override
	public ASTBoolean Visit(ASTBoolean bool) {
		return bool;
	}
	
	@Override
	public ASTCall Visit(ASTCall call) {
		return call;
	}
	
	@Override
	public ASTChar Visit(ASTChar car) {
		return car;
	}

	@Override
	public ASTConstant Visit(ASTConstant constant) {
		return constant;
	}

	@Override
	public ASTDeclaration Visit(ASTDeclaration decl) {
		return decl;
	}
	
	@Override
	public ASTDouble Visit(ASTDouble doub) {
		return doub;
	}

	@Override
	public ASTEnum Visit(ASTEnum enumer) {
		return enumer;
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
