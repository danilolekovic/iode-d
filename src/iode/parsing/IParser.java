package iode.parsing;

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
	
	Node parseArray();
	Node parseBoolean();
	Node parseCall();
	Node parseChar();
	Node parseConstant();
	Node parseDeclaration();
	Node parseDouble();
	Node parseEnum();
	Node parseFunction();
	Node parseImport();
	Node parseNil();
	Node parseNumber();
	Node parseParens();
	Node parseReturn();
	Node parseSetting();
	Node parseString();
	Node parseVariable();
	Node parseIdentifier();
}
