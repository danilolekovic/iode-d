package iode.scanning;

public enum TokenType {
	// Regular	
	IDENTIFIER,
	STRING,
	NUMBER,
	BOOLEAN,
	
	// Keywords
	LET,
	VAR,
	FUNCTION,
	IMPORT,
	RETURN,
	ENUM,
	
	// Symbols
	EQUALS,
	ADD,
	SUB,
	MUL,
	DIV,
	GT,
	LT,
	DOT,
	COMMA,
	COLON,
	LPAREN,
	RPAREN,
	LBRACE,
	RBRACE,
	LBRACK,
	RBRACK,
	NEWLINE
}
