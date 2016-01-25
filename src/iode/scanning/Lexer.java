package iode.scanning;

import java.util.ArrayList;

import iode.exceptions.LexerException;
import iode.util.Errors;

public class Lexer implements ILexer {

	private String code;
	private int index;
	private ArrayList<Token> tokens;
	private int line;
	
	public Lexer(String code) {
		this.code = code;
		this.index = -1;
		this.tokens = new ArrayList<Token>();
		this.line = 1;
	}

	@Override
	public Token peekToken() {
		return tokens.get(index + 1);
	}

	@Override
	public Token peekSpecific(int i) {
		return tokens.get(index + i);
	}

	@Override
	public Token nextToken() {
		index++;
		return tokens.get(index);
	}

	@Override
	public void tokenize() {
		int pos = 0;
		tokens.clear();
		
		while (pos < code.length()) {
			StringBuilder sb = new StringBuilder();
			
			if (Character.isLetter(code.charAt(pos)) || code.charAt(pos) == '_') {
				sb.append(code.charAt(pos));
				pos++;
				
				while (pos < code.length() && Character.isLetterOrDigit(code.charAt(pos)) || code.charAt(pos) == '_') {
					sb.append(code.charAt(pos));
					pos++;
				}
				
				String buffer = sb.toString();
				
				if (buffer.equals("let")) {
					tokens.add(new Token(TokenType.LET, buffer));
				} else if (buffer.equals("var")) {
					tokens.add(new Token(TokenType.VAR, buffer));
				} else if (buffer.equals("fn")) {
					tokens.add(new Token(TokenType.FUNCTION, buffer));
				} else if (buffer.equals("import")) {
					tokens.add(new Token(TokenType.IMPORT, buffer));
				} else if (buffer.equals("return")) {
					tokens.add(new Token(TokenType.RETURN, buffer));
				} else if (buffer.equals("enum")) {
					tokens.add(new Token(TokenType.ENUM, buffer));
				} else if (buffer.equals("true") || buffer.equals("false")) {
					tokens.add(new Token(TokenType.BOOLEAN, buffer));
				} else {
					tokens.add(new Token(TokenType.IDENTIFIER, buffer));
				}
				
				sb = new StringBuilder();
			} else if (Character.isDigit(code.charAt(pos))) {
				sb.append(code.charAt(pos));
				pos++;
				
				while (pos < code.length() && Character.isDigit(code.charAt(pos))) {
					sb.append(code.charAt(pos));
					pos++;
				}
				
				String buffer = sb.toString();
				
				tokens.add(new Token(TokenType.NUMBER, buffer));
				sb = new StringBuilder();
			} else if (code.charAt(pos) == '"') {
				pos++;
				
				while (pos < code.length() && code.charAt(pos) != '"') {
					sb.append(code.charAt(pos));
					pos++;
				}
				
				String buffer = sb.toString();
				
				pos++;
				
				tokens.add(new Token(TokenType.STRING, buffer));
				sb = new StringBuilder();
			} else if (code.charAt(pos) == '\n') {
				pos++;
				tokens.add(new Token(TokenType.NEWLINE, "\n"));
			} else if (Character.isWhitespace(code.charAt(pos))) {
				pos++;
			} else if (code.charAt(pos) == '+') {
				pos++;
				tokens.add(new Token(TokenType.ADD, "+"));
			} else if (code.charAt(pos) == '-') {
				pos++;
				tokens.add(new Token(TokenType.SUB, "-"));
			} else if (code.charAt(pos) == '*') {
				pos++;
				tokens.add(new Token(TokenType.MUL, "*"));
			} else if (code.charAt(pos) == '/') {
				pos++;
				tokens.add(new Token(TokenType.DIV, "/"));
			} else if (code.charAt(pos) == '>') {
				pos++;
				tokens.add(new Token(TokenType.GT, ">"));
			} else if (code.charAt(pos) == '<') {
				pos++;
				tokens.add(new Token(TokenType.LT, "<"));
			} else if (code.charAt(pos) == '.') {
				pos++;
				tokens.add(new Token(TokenType.DOT, "."));
			} else if (code.charAt(pos) == ',') {
				pos++;
				tokens.add(new Token(TokenType.COMMA, ","));
			} else if (code.charAt(pos) == '(') {
				pos++;
				tokens.add(new Token(TokenType.LPAREN, "("));
			} else if (code.charAt(pos) == ')') {
				pos++;
				tokens.add(new Token(TokenType.RPAREN, ")"));
			} else if (code.charAt(pos) == '{') {
				pos++;
				tokens.add(new Token(TokenType.LBRACE, "{"));
			} else if (code.charAt(pos) == '}') {
				pos++;
				tokens.add(new Token(TokenType.RBRACE, "}"));
			} else if (code.charAt(pos) == '[') {
				pos++;
				tokens.add(new Token(TokenType.LBRACK, "["));
			} else if (code.charAt(pos) == ']') {
				pos++;
				tokens.add(new Token(TokenType.RBRACK, "]"));
			} else if (code.charAt(pos) == '=') {
				pos++;
				tokens.add(new Token(TokenType.EQUALS, "="));
			} else if (code.charAt(pos) == ':') {
				pos++;
				tokens.add(new Token(TokenType.COLON, ":"));
			} else if (code.charAt(pos) == '#') {
				pos++;
				
				while (code.charAt(pos) != '#') {
					pos++;
				}
				
				pos++;
				
				line++;
			} else {
				Errors.throwException(new LexerException("Illegal symbol: " + code.charAt(pos), line));
			}
		}
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

	public int getIndex() {
		return index;
	}

	public void setIndex(int index) {
		this.index = index;
	}

	public ArrayList<Token> getTokens() {
		return tokens;
	}

	public void setTokens(ArrayList<Token> tokens) {
		this.tokens = tokens;
	}

	public int getLine() {
		return line;
	}

	public void setLine(int line) {
		this.line = line;
	}
}
