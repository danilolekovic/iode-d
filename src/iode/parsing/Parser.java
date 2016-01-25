package iode.parsing;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import iode.ast.Node;
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
import iode.ast.nodes.ASTNil;
import iode.ast.nodes.ASTNumber;
import iode.ast.nodes.ASTReturn;
import iode.ast.nodes.ASTSetting;
import iode.ast.nodes.ASTString;
import iode.ast.nodes.ASTVariable;
import iode.exceptions.ParserException;
import iode.scanning.Lexer;
import iode.scanning.Token;
import iode.scanning.TokenType;
import iode.util.Errors;

public class Parser implements IParser {
	
	private int pos;
	private int line;
	private int totalTokens;
	private Lexer lexer;
	
	public Parser(Lexer lexer) {
		this.lexer = lexer;
		this.pos = 0;
		this.line = 1;
		this.totalTokens = lexer.getTokens().size();
	}

	@Override
	public Token peekToken() {
		return lexer.peekToken();
	}

	@Override
	public boolean peekCheck(TokenType type) {
		return lexer.peekToken().getType() == type;
	}

	@Override
	public boolean peekSpecificCheck(TokenType type, int i) {
		return lexer.peekSpecific(i).getType() == type;
	}

	@Override
	public Token peekSpecific(int i) {
		return lexer.peekSpecific(i);
	}

	@Override
	public Token nextToken() {
		pos++;

        if (peekCheck(TokenType.NEWLINE)) {
            line++;
        }

        return lexer.nextToken();
	}

	@Override
	public void skipNewline() {
		if (!(totalTokens >= pos)) {
			if (peekCheck(TokenType.NEWLINE)) {
				line++;
				nextToken();
			}
		}
	}

	@Override
	public Node start() {
		TokenType t = peekToken().getType();
		
		switch (t) {
		case LET:
			return parseConstant();
		case VAR:
			return parseDeclaration();
		case FUNCTION:
			return parseFunction();
		case IMPORT:
			return parseImport();
		case IDENTIFIER:
			return parseIdentifier();
		case RETURN:
			return parseReturn();
		case ENUM:
			return parseEnum();
		case NEWLINE:
			nextToken();
			skipNewline();
			return new ASTNewline();
		default:
			Errors.throwException(new ParserException("Unexpected token: " + t, line));
			return null;
		}
	}
	
	@Override
	public Node literal() {
		TokenType t = peekToken().getType();
		
		switch (t) {
		case LBRACK:
			return parseArray();
		case BOOLEAN:
			return parseBoolean();
		case NUMBER:
			return parseNumber();
		case DOUBLE:
			return parseDouble();
		case STRING:
			return parseString();
		case IDENTIFIER:
			return parseVariable();
		case CHAR:
			return parseChar();
		case NIL:
			return parseNil();
		default:
			Errors.throwException(new ParserException("Unexpected token: " + t + ". Expected a boolean, number, string, identifier or other literal type.", line));
			return null;
		}
	}
	
	@Override
	public ASTArray parseArray() {
		nextToken();
		skipNewline();
		ArrayList<Node> values = new ArrayList<Node>();
		
		while (!peekCheck(TokenType.RBRACK)) {
			values.add(literal());
			
			if (peekCheck(TokenType.COMMA)) {
				nextToken();
				skipNewline();
				continue;
			} else if (peekCheck(TokenType.RBRACK)) {
				break;
			} else {
				Errors.throwException(new ParserException("Expected ',' or ']'", line));
			}
		}
		
		if (peekCheck(TokenType.RBRACK)) {
			nextToken();
		} else {
			Errors.throwException(new ParserException("Expected ']'", line));
		}
		
		return new ASTArray(values);
	}

	@Override
	public ASTBoolean parseBoolean() {
		return new ASTBoolean(Boolean.parseBoolean(nextToken().getValue()));
	}
	
	@Override
	public ASTCall parseCall() {
		String name = nextToken().getValue();
		skipNewline();
		
		if (peekCheck(TokenType.LPAREN)) {
			nextToken();
			skipNewline();
			
			ArrayList<Node> args = new ArrayList<Node>();
			
			while (!peekCheck(TokenType.RPAREN)) {
				args.add(literal());
				
				if (peekCheck(TokenType.COMMA)) {
					nextToken();
					skipNewline();
					continue;
				} else if (peekCheck(TokenType.RPAREN)) {
					break;
				} else {
					Errors.throwException(new ParserException("Expected ',' or ')'", line));
				}
			}
			
			if (peekCheck(TokenType.RPAREN)) {
				nextToken();
				
				if (peekCheck(TokenType.NEWLINE)) {
					nextToken();
					skipNewline();
					
					return new ASTCall(name, args);
				} else {
					Errors.throwException(new ParserException("Expected a newline", line));
				}
			} else {
				Errors.throwException(new ParserException("Expected ')'", line));
			}
		} else {
			Errors.throwException(new ParserException("Expected '('", line));
		}
		
		return null;
	}
	
	@Override
	public ASTChar parseChar() {
		return new ASTChar(nextToken().getValue().charAt(0));
	}

	@Override
	public ASTConstant parseConstant() {
		nextToken();
		skipNewline();
		
		if (peekCheck(TokenType.IDENTIFIER)) {
			String name = nextToken().getValue();
			skipNewline();
			
			if (peekCheck(TokenType.EQUALS)) {
				nextToken();
				skipNewline();
				
				Node value = literal();
				
				if (peekCheck(TokenType.NEWLINE)) {
					nextToken();
					skipNewline();
					
					return new ASTConstant(name, value);
				} else {
					Errors.throwException(new ParserException("Expected a new line", line));
				}
			} else {
				Errors.throwException(new ParserException("Expected '='", line));
			}
		} else {
			Errors.throwException(new ParserException("Expected a name", line));
		}
		
		return null;
	}

	@Override
	public ASTDeclaration parseDeclaration() {
		nextToken();
		skipNewline();
		
		if (peekCheck(TokenType.IDENTIFIER)) {
			String name = nextToken().getValue();
			skipNewline();
			
			if (peekCheck(TokenType.COLON)) {
				nextToken();
				skipNewline();
				
				if (peekCheck(TokenType.IDENTIFIER)) {
					String type = nextToken().getValue();
					
					if (peekCheck(TokenType.EQUALS)) {
						skipNewline();
						nextToken();
						skipNewline();
						
						Node value = literal();
						
						if (peekCheck(TokenType.NEWLINE)) {
							nextToken();
							skipNewline();
							
							return new ASTDeclaration(name, type, value);
						} else {
							Errors.throwException(new ParserException("Expected a new line", line));
						}
					} else if (peekCheck(TokenType.NEWLINE)) {
						return new ASTDeclaration(name, type, null);
					} else {
						Errors.throwException(new ParserException("Expected '=' or a new line", line));
					}
				} else {
					Errors.throwException(new ParserException("Expected a type", line));
				}
			} else {
				Errors.throwException(new ParserException("Expected ':'", line));
			}
		} else {
			Errors.throwException(new ParserException("Expected a name", line));
		}
		
		return null;
	}
	
	@Override
	public ASTDouble parseDouble() {
		return new ASTDouble(Double.parseDouble(nextToken().getValue()));
	}

	@Override
	public ASTEnum parseEnum() {
		nextToken();
		skipNewline();
		
		if (peekCheck(TokenType.IDENTIFIER)) {
			String name = nextToken().getValue();
			skipNewline();
			
			if (peekCheck(TokenType.LPAREN)) {
				nextToken();
				skipNewline();
				ArrayList<Node> elements = new ArrayList<Node>();
				
				while (!peekCheck(TokenType.RPAREN)) {
					if (peekCheck(TokenType.IDENTIFIER)) {
						elements.add(parseVariable());
					} else {
						Errors.throwException(new ParserException("Expected an identifier", line));
					}
					
					if (peekCheck(TokenType.COMMA)) {
						nextToken();
						skipNewline();
						continue;
					} else if (peekCheck(TokenType.RPAREN)) {
						break;
					} else {
						Errors.throwException(new ParserException("Expected ',' or ')'", line));
					}
				}
				
				if (peekCheck(TokenType.RPAREN)) {
					nextToken();
					
					if (peekCheck(TokenType.NEWLINE)) {
						nextToken();
						skipNewline();
						
						return new ASTEnum(name, elements);
					} else {
						Errors.throwException(new ParserException("Expected a new line", line));
					}
				} else {
					Errors.throwException(new ParserException("Expected ')'", line));
				}
			} else {
				Errors.throwException(new ParserException("Expected '('", line));
			}
		} else {
			Errors.throwException(new ParserException("Expected a name", line));
		}
		
		return null;
	}

	@Override
	public ASTFunction parseFunction() {
		nextToken();
		skipNewline();
		
		if (peekCheck(TokenType.IDENTIFIER)) {
			String name = nextToken().getValue();
			skipNewline();
			
			if (peekCheck(TokenType.LPAREN)) {
				nextToken();
				skipNewline();
				
				Map<String, String> args = new HashMap<String, String>();
				
				while (!peekCheck(TokenType.RPAREN)) {
					if (peekCheck(TokenType.IDENTIFIER)) {
						// TODO: Validate type
						String type = nextToken().getValue();
						skipNewline();
						
						if (peekCheck(TokenType.IDENTIFIER)) {
							String argName = nextToken().getValue();
							skipNewline();
							
							args.put(argName, type);
							
							if (peekCheck(TokenType.COMMA)) {
								nextToken();
								skipNewline();
							} else {
								Errors.throwException(new ParserException("Expected ','", line));
							}
						} else {
							Errors.throwException(new ParserException("Expected a parameter name", line));
						}
					} else {
						Errors.throwException(new ParserException("Expected a parameter type", line));
					}
				}
				
				if (peekCheck(TokenType.RPAREN)) {
					nextToken();
					skipNewline();
					String returnType = "Void";
					
					if (peekCheck(TokenType.GT)) {
						nextToken();
						skipNewline();
						
						if (peekCheck(TokenType.IDENTIFIER)) {
							returnType = nextToken().getValue();
							skipNewline();
							
							if (peekCheck(TokenType.LBRACE)) {
								nextToken();
								skipNewline();
								
								ArrayList<Node> body = new ArrayList<Node>();
								
								while (!peekCheck(TokenType.RBRACE)) {
									body.add(start());
									skipNewline();
								}
								
								if (peekCheck(TokenType.RBRACE)) {
									nextToken();
									skipNewline();
									
									return new ASTFunction(name, args, body, returnType);
								} else {
									Errors.throwException(new ParserException("Expected '}'", line));
								}
							} else {
								Errors.throwException(new ParserException("Expected '{'", line));
							}
						} else {
							Errors.throwException(new ParserException("Expected a return type", line));
						}
					} else {
						Errors.throwException(new ParserException("Expected '>'", line));
					}
				} else {
					Errors.throwException(new ParserException("Expected ')'", line));
				}
			} else {
				Errors.throwException(new ParserException("Expected '('", line));
			}
		} else {
			Errors.throwException(new ParserException("Expected a name", line));
		}
		
		return null;
	}
	
	@Override
	public ASTImport parseImport() {
		nextToken();
		skipNewline();
		
		if (peekCheck(TokenType.IDENTIFIER)) {
			String module = nextToken().getValue();
			
			if (peekCheck(TokenType.NEWLINE)) {
				nextToken();
				skipNewline();
				
				return new ASTImport(module);
			} else {
				Errors.throwException(new ParserException("Expected a new line", line));
			}
		} else {
			Errors.throwException(new ParserException("Expected a module name", line));
		}
		
		return null;
	}

	@Override
	public ASTNil parseNil() {
		nextToken();
		return new ASTNil();
	}

	@Override
	public ASTNumber parseNumber() {
		return new ASTNumber(Integer.parseInt(nextToken().getValue()));
	}
	
	@Override
	public ASTReturn parseReturn() {
		nextToken();
		skipNewline();
		
		Node expression = literal();
		
		if (peekCheck(TokenType.NEWLINE)) {
			nextToken();
			skipNewline();
		} else {
			Errors.throwException(new ParserException("Expected a new line", line));
		}
		
		return new ASTReturn(expression);
	}

	@Override
	public ASTSetting parseSetting() {
		String name = nextToken().getValue();
		skipNewline();
		
		if (peekCheck(TokenType.EQUALS)) {
			nextToken();
			skipNewline();
			
			Node expression = literal();
			
			if (peekCheck(TokenType.NEWLINE)) {
				nextToken();
				skipNewline();
				
				return new ASTSetting(name, expression);
			} else {
				Errors.throwException(new ParserException("Expected a new line", line));
			}
		} else {
			Errors.throwException(new ParserException("Expected an expression", line));
		}
		
		return null;
	}

	@Override
	public ASTString parseString() {
		return new ASTString(nextToken().getValue());
	}

	@Override
	public ASTVariable parseVariable() {
		return new ASTVariable(nextToken().getValue());
	}
	
	@Override
	public Node parseIdentifier() {
		if (peekSpecificCheck(TokenType.LPAREN, 2)) {
			return parseCall();
		} else if (peekSpecificCheck(TokenType.EQUALS, 2)) {
			return parseSetting();
		} else {
			Errors.throwException(new ParserException("Expected a '(' after identifier", line));
		}
		
		return null;
	}
	
	public int getPos() {
		return pos;
	}

	public void setPos(int pos) {
		this.pos = pos;
	}

	public int getLine() {
		return line;
	}

	public void setLine(int line) {
		this.line = line;
	}

	public int getTotalTokens() {
		return totalTokens;
	}

	public void setTotalTokens(int totalTokens) {
		this.totalTokens = totalTokens;
	}

	public Lexer getLexer() {
		return lexer;
	}

	public void setLexer(Lexer lexer) {
		this.lexer = lexer;
	}
}
