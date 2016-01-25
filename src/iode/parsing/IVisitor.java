package iode.parsing;

import iode.ast.nodes.*;

public interface IVisitor {
	ASTArray Visit(ASTArray array);
	ASTBoolean Visit(ASTBoolean bool);
	ASTCall Visit(ASTCall call);
	ASTConstant Visit(ASTConstant constant);
	ASTDeclaration Visit(ASTDeclaration decl);
	ASTEnum Visit(ASTEnum enumer);
	ASTFunction Visit(ASTFunction func);
	ASTImport Visit(ASTImport imp);
	ASTNewline Visit(ASTNewline nl);
	ASTNumber Visit(ASTNumber num);
	ASTReturn Visit(ASTReturn ret);
	ASTSetting Visit(ASTSetting set);
	ASTString Visit(ASTString str);
	ASTVariable Visit(ASTVariable var);
}
