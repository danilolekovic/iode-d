package iode.parsing;

import iode.ast.nodes.ASTArray;
import iode.ast.nodes.ASTBoolean;
import iode.ast.nodes.ASTCall;
import iode.ast.nodes.ASTConstant;
import iode.ast.nodes.ASTDeclaration;
import iode.ast.nodes.ASTFunction;
import iode.ast.nodes.ASTImport;
import iode.ast.nodes.ASTNumber;
import iode.ast.nodes.ASTReturn;
import iode.ast.nodes.ASTSetting;
import iode.ast.nodes.ASTString;
import iode.ast.nodes.ASTVariable;
import iode.ast.Node;
import iode.scanning.Token;
import iode.scanning.TokenType;

public interface IParser {
	Token peekToken();
	boolean peekCheck(TokenType type);
	boolean peekSpecificCheck(TokenType type, int i);
	Token peekSpecific(int i);
	Token nextToken();
	void skipNewline();
	Node start();
	Node literal();
	
	ASTArray parseArray();
	ASTBoolean parseBoolean();
	ASTCall parseCall();
	ASTConstant parseConstant();
	ASTDeclaration parseDeclaration();
	ASTFunction parseFunction();
	ASTImport parseImport();
	ASTNumber parseNumber();
	ASTReturn parseReturn();
	ASTSetting parseSetting();
	ASTString parseString();
	ASTVariable parseVariable();
	Node parseIdentifier();
}
