package iode.parsing;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import iode.ast.Node;
import iode.ast.nodes.ASTArray;
import iode.ast.nodes.ASTBinaryOp;
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
import iode.ast.nodes.ASTParenthesis;
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
			Errors.throwException(new ParserException("Unexpected token: " + t, line, "constant declaration, variable declaration, function, import, call, return, enumeration, or new line"));
			return null;
		}
	}
	
	@Override
	public Node literal() {
		TokenType t = peekToken().getType();
		
		switch (t) {
		case LPAREN:
			return parseParens();
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
			Errors.throwException(new ParserException("Unexpected token: " + t, line, "parenthesis, array, boolean, number, double, string, identifier, character, or nil"));
			return null;
		}
	}
	
	@Override
	public Node parseArray() {
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
				Errors.throwException(new ParserException("Expected ',' or ']'", peekToken().getValue(), line));
			}
		}
		
		if (peekCheck(TokenType.RBRACK)) {
			nextToken();
		} else {
			Errors.throwException(new ParserException("Expected ']'", peekToken().getValue(), line));
		}
		
		return new ASTArray(values);
	}

	@Override
	public Node parseBoolean() {
		return new ASTBoolean(Boolean.parseBoolean(nextToken().getValue()));
	}
	
	@Override
	public Node parseCall() {
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
					Errors.throwException(new ParserException("Expected ',' or ')'", peekToken().getValue(), line));
				}
			}
			
			if (peekCheck(TokenType.RPAREN)) {
				nextToken();
				
				if (peekCheck(TokenType.NEWLINE)) {
					nextToken();
					skipNewline();
					
					return new ASTCall(name, args);
				} else {
					Errors.throwException(new ParserException("Expected a newline", peekToken().getValue(), line));
				}
			} else {
				Errors.throwException(new ParserException("Expected ')'", peekToken().getValue(), line));
			}
		} else {
			Errors.throwException(new ParserException("Expected '('", peekToken().getValue(), line));
		}
		
		return null;
	}
	
	@Override
	public Node parseChar() {
		return new ASTChar(nextToken().getValue().charAt(0));
	}

	@Override
	public Node parseConstant() {
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
					Errors.throwException(new ParserException("Expected a new line", peekToken().getValue(), line));
				}
			} else {
				Errors.throwException(new ParserException("Expected '='", peekToken().getValue(), line));
			}
		} else {
			Errors.throwException(new ParserException("Expected a name", peekToken().getValue(), line));
		}
		
		return null;
	}

	@Override
	public Node parseDeclaration() {
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
							Errors.throwException(new ParserException("Expected a new line", peekToken().getValue(), line));
						}
					} else if (peekCheck(TokenType.NEWLINE)) {
						return new ASTDeclaration(name, type, null);
					} else {
						Errors.throwException(new ParserException("Expected '=' or a new line", peekToken().getValue(), line));
					}
				} else {
					Errors.throwException(new ParserException("Expected a type", peekToken().getValue(), line));
				}
			} else {
				Errors.throwException(new ParserException("Expected ':'", peekToken().getValue(), line));
			}
		} else {
			Errors.throwException(new ParserException("Expected a name", peekToken().getValue(), line));
		}
		
		return null;
	}
	
	@Override
	public Node parseDouble() {
		return new ASTDouble(Double.parseDouble(nextToken().getValue()));
	}

	@Override
	public Node parseEnum() {
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
						Errors.throwException(new ParserException("Expected an identifier", peekToken().getValue(), line));
					}
					
					if (peekCheck(TokenType.COMMA)) {
						nextToken();
						skipNewline();
						continue;
					} else if (peekCheck(TokenType.RPAREN)) {
						break;
					} else {
						Errors.throwException(new ParserException("Expected ',' or ')'", peekToken().getValue(), line));
					}
				}
				
				if (peekCheck(TokenType.RPAREN)) {
					nextToken();
					
					if (peekCheck(TokenType.NEWLINE)) {
						nextToken();
						skipNewline();
						
						return new ASTEnum(name, elements);
					} else {
						Errors.throwException(new ParserException("Expected a new line", peekToken().getValue(), line));
					}
				} else {
					Errors.throwException(new ParserException("Expected ')'", peekToken().getValue(), line));
				}
			} else {
				Errors.throwException(new ParserException("Expected '('", peekToken().getValue(), line));
			}
		} else {
			Errors.throwException(new ParserException("Expected a name", peekToken().getValue(), line));
		}
		
		return null;
	}

	@Override
	public Node parseFunction() {
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
							} else if (peekCheck(TokenType.RPAREN)) {
								break;
							} else {
								Errors.throwException(new ParserException("Expected ','", peekToken().getValue(), line));
							}
						} else {
							Errors.throwException(new ParserException("Expected a parameter name", peekToken().getValue(), line));
						}
					} else {
						Errors.throwException(new ParserException("Expected a parameter type", peekToken().getValue(), line));
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
									Errors.throwException(new ParserException("Expected '}'", peekToken().getValue(), line));
								}
							} else {
								Errors.throwException(new ParserException("Expected '{'", peekToken().getValue(), line));
							}
						} else {
							Errors.throwException(new ParserException("Expected a return type", peekToken().getValue(), line));
						}
					} else {
						Errors.throwException(new ParserException("Expected '>'", peekToken().getValue(), line));
					}
				} else {
					Errors.throwException(new ParserException("Expected ')'", peekToken().getValue(), line));
				}
			} else {
				Errors.throwException(new ParserException("Expected '('", peekToken().getValue(), line));
			}
		} else {
			Errors.throwException(new ParserException("Expected a name", peekToken().getValue(), line));
		}
		
		return null;
	}
	
	@Override
	public Node parseImport() {
		nextToken();
		skipNewline();
		
		if (peekCheck(TokenType.IDENTIFIER)) {
			if (peekToken().getValue().equals("std")) {
				nextToken();
				skipNewline();
				
				if (peekCheck(TokenType.IDENTIFIER)) {
					String module = nextToken().getValue();
					
					if (peekCheck(TokenType.NEWLINE)) {
						nextToken();
						skipNewline();
						
						return new ASTImport(module, true);
					} else {
						Errors.throwException(new ParserException("Expected a new line", peekToken().getValue(), line));
					}
				} else {
					Errors.throwException(new ParserException("Expected an std module name", peekToken().getValue(), line));
				}
			} else {
				String module = nextToken().getValue();
				
				if (peekCheck(TokenType.NEWLINE)) {
					nextToken();
					skipNewline();
					
					return new ASTImport(module, true);
				} else {
					Errors.throwException(new ParserException("Expected a new line", peekToken().getValue(), line));
				}
			}
		} else {
			Errors.throwException(new ParserException("Expected a module name or 'std' specification", peekToken().getValue(), line));
		}
		
		return null;
	}

	@Override
	public Node parseNil() {
		nextToken();
		return new ASTNil();
	}

	@Override
	public Node parseNumber() {
		Node toReturn = new ASTNumber(Integer.parseInt(nextToken().getValue()));
		
		if (peekCheck(TokenType.ADD) || peekCheck(TokenType.DIV) || peekCheck(TokenType.SUB) || peekCheck(TokenType.MUL)) {
			while (peekCheck(TokenType.ADD) || peekCheck(TokenType.DIV) || peekCheck(TokenType.SUB) || peekCheck(TokenType.MUL)) {
				skipNewline();
				String op = nextToken().getValue();
				skipNewline();
				
				if (peekCheck(TokenType.IDENTIFIER) || peekCheck(TokenType.NUMBER)) {
					Node next = literal();
					toReturn = new ASTBinaryOp(toReturn, op, next);
				} else {
					Errors.throwException(new ParserException("Expected an identifier or a number", peekToken().getValue(), line));
				}
			}
		}
		
		return toReturn;
	}
	
	@Override
	public Node parseParens() {
		nextToken();
		skipNewline();
		Node n = literal();
		
		if (peekCheck(TokenType.RPAREN)) {
			nextToken();
			skipNewline();
			
			return new ASTParenthesis(n);
		} else {
			Errors.throwException(new ParserException("Expected ')", peekToken().getValue(), line));
		}
		
		return null;
	}

	@Override
	public Node parseReturn() {
		nextToken();
		skipNewline();
		
		Node expression = literal();
		
		if (peekCheck(TokenType.NEWLINE)) {
			nextToken();
			skipNewline();
		} else {
			Errors.throwException(new ParserException("Expected a new line", peekToken().getValue(), line));
		}
		
		return new ASTReturn(expression);
	}

	@Override
	public Node parseSetting() {
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
				Errors.throwException(new ParserException("Expected a new line", peekToken().getValue(), line));
			}
		} else {
			Errors.throwException(new ParserException("Expected an expression", peekToken().getValue(), line));
		}
		
		return null;
	}

	@Override
	public Node parseString() {
		Node toReturn = new ASTString(nextToken().getValue());
		
		if (peekCheck(TokenType.ADD) || peekCheck(TokenType.DIV) || peekCheck(TokenType.SUB) || peekCheck(TokenType.MUL)) {
			while (peekCheck(TokenType.ADD) || peekCheck(TokenType.DIV) || peekCheck(TokenType.SUB) || peekCheck(TokenType.MUL)) {
				skipNewline();
				String op = nextToken().getValue();
				skipNewline();
				
				if (peekCheck(TokenType.IDENTIFIER) || peekCheck(TokenType.STRING)) {
					Node next = literal();
					toReturn = new ASTBinaryOp(toReturn, op, next);
				} else {
					Errors.throwException(new ParserException("Expected an identifier or a number", peekToken().getValue(), line));
				}
			}
		}
		
		return toReturn;
	}

	@Override
	public Node parseVariable() {
		Node toReturn = new ASTVariable(nextToken().getValue());
		
		if (peekCheck(TokenType.ADD) || peekCheck(TokenType.DIV) || peekCheck(TokenType.SUB) || peekCheck(TokenType.MUL)) {
			while (peekCheck(TokenType.ADD) || peekCheck(TokenType.DIV) || peekCheck(TokenType.SUB) || peekCheck(TokenType.MUL)) {
				skipNewline();
				String op = nextToken().getValue();
				skipNewline();
				
				if (peekCheck(TokenType.IDENTIFIER) || peekCheck(TokenType.STRING) || peekCheck(TokenType.NUMBER)) {
					Node next = literal();
					toReturn = new ASTBinaryOp(toReturn, op, next);
				} else {
					Errors.throwException(new ParserException("Expected an identifier or a number", peekToken().getValue(), line));
				}
			}
		}
		
		return toReturn;
	}
	
	@Override
	public Node parseIdentifier() {
		if (peekSpecificCheck(TokenType.LPAREN, 2)) {
			return parseCall();
		} else if (peekSpecificCheck(TokenType.EQUALS, 2)) {
			return parseSetting();
		} else {
			Errors.throwException(new ParserException("Expected a '(' after identifier", peekToken().getValue(), line));
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
