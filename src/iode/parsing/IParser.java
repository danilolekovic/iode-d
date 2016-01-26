package iode.parsing;

import iode.ast.nodes.*;
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
	ASTChar parseChar();
	ASTConstant parseConstant();
	ASTDeclaration parseDeclaration();
	ASTDouble parseDouble();
	ASTEnum parseEnum();
	ASTFunction parseFunction();
	ASTImport parseImport();
	ASTNil parseNil();
	ASTNumber parseNumber();
	ASTParenthesis parseParens();
	ASTReturn parseReturn();
	ASTSetting parseSetting();
	ASTString parseString();
	ASTVariable parseVariable();
	Node parseIdentifier();
}
