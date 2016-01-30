module iode.parsing.parser;

import std.stdio;
import std.conv;
import iode.lexical.lexer;
import iode.lexical.token;
import iode.ast.node;
import iode.errors.parserError;

/* Converts tokens into AST */
class Parser {
    private Lexer lexer;
    public int pos;
    private int line;
    public ulong totalTokens;

    this(Lexer lexer) {
        this.lexer = lexer;
        this.pos = 0;
        this.line = 1;
        this.totalTokens = lexer.tokens.length;
    }

    /* checks up on the next token */
    public Token peekToken() {
        return lexer.peekToken();
    }

    /* checks if the next token is a certain type */
    public bool peekCheck(TokenType type) {
        return lexer.peekToken().getType == type;
    }

    /* checks if a specific token is a certain type */
    public bool peekSpecificCheck(TokenType type, int i) {
        return lexer.peekSpecific(i).getType() == type;
    }

    /* checks up on a specific token */
    public Token peekSpecific(int i) {
        return lexer.peekSpecific(i);
    }

    /* gets the next token */
    public Token nextToken() {
        pos++;

        if (peekCheck(TokenType.NEWLINE)) {
            line++;
        }

        return lexer.nextToken();
    }

    /* gets the next token and skips newlines */
    public Token nextToken(bool skip) {
        if (skip) {
            return nextToken();
        } else {
            Token t = nextToken();
            skipNewline();
            return t;
        }
    }

    /* skips newlines */
    public void skipNewline() {
        if (!(totalTokens >= pos)) {
            while (peekCheck(TokenType.NEWLINE)) {
                nextToken();
            }
        }
    }

    /* parses numbers */
    public Node parseNumber() {
        return new NodeNumber(to!double(nextToken().getValue()));
    }

    /* parses strings */
    public Node parseString() {
        return new NodeString(nextToken().getValue());
    }

    /* parses boolean */
    public Node parseBoolean() {
        return new NodeNumber(to!bool(nextToken().getValue()));
    }

    /* parses null */
    public Node parseNull() {
        nextToken();
        return new NodeNull();
    }

    /* parses variable declaration */
    public Node parseDeclaration() {
        nextToken(true);

        if (peekCheck(TokenType.IDENT)) {
            string name = nextToken(true).getValue();

            if (peekCheck(TokenType.EQUALS)) {
                nextToken(true);

                Node next = literal();

                if (peekCheck(TokenType.NEWLINE)) {
                    nextToken(true);

                    return new NodeDeclaration(name, next);
                } else {
                    throw new ParserException("Expected a newline", line);
                }
            } else {
                throw new ParserException("Expected '='", line);
            }
        } else {
            throw new ParserException("Expected an identifier", line);
        }
    }

    /* parses an ident as a literal */
    public Node parseIdentLiteral() {
        string ident = nextToken().getValue();

        if (peekCheck(TokenType.LPAREN)) {
            nextToken(true);
            Node[] args;

            while (!peekCheck(TokenType.RPAREN)) {
                args ~= literal();

                if (!peekCheck(TokenType.COMMA) && !peekCheck(TokenType.RPAREN)) {
                    throw new ParserException("Expected ',' or ')'", line);
                }

                if (peekCheck(TokenType.COMMA)) {
                    nextToken(true);
                } else if (peekCheck(TokenType.RPAREN)) {
                    break;
                }
            }

            if (peekCheck(TokenType.RPAREN)) {
                nextToken();

                return new NodeCall(ident, args);
            } else {
                throw new ParserException("Expected ',' or ')'", line);
            }
        } else {
            return new NodeVariable(ident);
        }
    }

    /* parses an ident as an expression */
    public Node parseIdent() {
        string ident = nextToken(true).getValue();

        if (peekCheck(TokenType.LPAREN)) {
            nextToken(true);
            Node[] args;

            while (!peekCheck(TokenType.RPAREN)) {
                args ~= literal();

                if (!peekCheck(TokenType.COMMA) && !peekCheck(TokenType.RPAREN)) {
                    throw new ParserException("Expected ',' or ')'", line);
                }

                if (peekCheck(TokenType.COMMA)) {
                    nextToken(true);
                } else if (peekCheck(TokenType.RPAREN)) {
                    break;
                }
            }

            if (peekCheck(TokenType.RPAREN)) {
                nextToken();

                if (peekCheck(TokenType.NEWLINE)) {
                    nextToken(true);

                    return new NodeCall(ident, args);
                } else {
                    throw new ParserException("Expected a newline", line);
                }
            } else {
                throw new ParserException("Expected ',' or ')'", line);
            }
        } else {
            throw new ParserException("Expected nothing or '(' after identifier", line);
        }
    }

    /* gets the next literal */
    public Node literal() {
        TokenType t = peekToken().getType();

        switch (t) {
            default:
                throw new ParserException("Unexpected token '" ~ t ~ "'", line);
            case TokenType.NUMBER:
                return parseNumber();
            case TokenType.BOOL:
                return parseBoolean();
            case TokenType.IDENT:
                return parseIdentLiteral();
            case TokenType.STRING:
                return parseString();
            case TokenType.NULL:
                return parseNull();
        }
    }

    /* gets the next statement */
    public Node start() {
        TokenType t = peekToken().getType();

        switch (t) {
            default:
                throw new ParserException("Unexpected token '" ~ t ~ "'", line);
            case TokenType.VAR:
                return parseDeclaration();
            case TokenType.IDENT:
                return parseIdent();
        }
    }
}
