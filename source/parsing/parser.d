module iode.parsing.parser;

import std.stdio;
import std.conv;
import iode.lexical.lexer;
import iode.lexical.token;
import iode.ast.node;
import iode.gen.stash;
import iode.errors.error;

/* Converts tokens into AST */
class Parser {
    private Lexer lexer;
    public int pos;
    public ulong totalTokens;

    this(Lexer lexer) {
        this.lexer = lexer;
        this.pos = 0;
        this.totalTokens = lexer.tokens.length;
        Stash.line = 1;
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
            Stash.line++;
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
            while (peekCheck(TokenType.NEWLINE) || peekCheck(TokenType.SEMICOLON)) {
                nextToken();

                if (peekCheck(TokenType.NEWLINE)) {
                    Stash.line++;
                }
            }
        }
    }

    /* checks if the next token is a terminator */
    public bool terminator() {
        return peekCheck(TokenType.NEWLINE) || peekCheck(TokenType.SEMICOLON);
    }

    /* parses numbers */
    public Node parseNumber() {
        ulong converted = to!ulong(nextToken().getValue());
        Node left = new NodeNumber(converted);
        string op = null;
        Node right = null;

        while (peekCheck(TokenType.ADD) || peekCheck(TokenType.SUB)
            || peekCheck(TokenType.MUL) || peekCheck(TokenType.DIV)) {
            skipNewline();
            op = this.nextToken().getValue();
            skipNewline();

            if (peekCheck(TokenType.NUMBER)) {
                right = cast(NodeNumber)this.parseNumber();
            } else if (peekCheck(TokenType.DOUBLE)) {
                right = cast(NodeDouble)this.parseDouble();
            } else if (peekCheck(TokenType.IDENT)) {
                right = new NodeVariable(nextToken().getValue());
            } else if (peekCheck(TokenType.LPAREN)) {
                right = this.parseParens();
            } else {
                new IodeError("Expected a number, double, or variable after binary operation", Stash.line, "Error", true).call();
                return null;
            }
        }

        if (op != null) {
            left = new NodeBinaryOp(left, op, right);
        }

        return left;
    }

    /* parses doubles */
    public Node parseDouble() {
        double converted = to!double(nextToken().getValue());
        Node left = new NodeDouble(converted);
        string op = null;
        Node right = null;

        while (peekCheck(TokenType.ADD) || peekCheck(TokenType.SUB)
            || peekCheck(TokenType.MUL) || peekCheck(TokenType.DIV)) {
            skipNewline();
            op = this.nextToken().getValue();
            skipNewline();

            if (peekCheck(TokenType.NUMBER)) {
                right = cast(NodeNumber)this.parseNumber();
            } else if (peekCheck(TokenType.DOUBLE)) {
                right = cast(NodeDouble)this.parseDouble();
            } else if (peekCheck(TokenType.IDENT)) {
                right = new NodeVariable(nextToken().getValue());
            } else if (peekCheck(TokenType.LPAREN)) {
                right = this.parseParens();
            } else {
                new IodeError("Expected a number, double, or variable after binary operation", Stash.line, "Error", true).call();
                return null;
            }
        }

        if (op != null) {
            left = new NodeBinaryOp(left, op, right);
        }

        return left;
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
    public Node parseDeclaration(bool constant) {
        nextToken(true);

        if (peekCheck(TokenType.IDENT)) {
            string name = nextToken(true).getValue();

            if (peekCheck(TokenType.EQUALS)) {
                nextToken(true);

                Node next = literal();

                if (terminator()) {
                    nextToken(true);

                    return new NodeDeclaration(constant, name, next);
                } else {
                    new IodeError("Expected a terminator (newline or semicolon)", Stash.line, "Error", true).call();
                    return null;
                }
            } else if (peekCheck(TokenType.COLON)) {
                nextToken(true);

                if (peekCheck(TokenType.IDENT)) {
                    string type = nextToken(true).getValue();

                    if (peekCheck(TokenType.EQUALS)) {
                        nextToken(true);

                        Node next = literal();

                        if (terminator()) {
                            nextToken(true);

                            return new NodeTypedDeclaration(constant, name, type, next);
                        } else {
                            new IodeError("Expected a terminator (newline or semicolon)", Stash.line, "Error", true).call();
                            return null;
                        }
                    } else {
                        new IodeError("Expected '=' (denotes declaration) or ':' (denotes type)", Stash.line, "Error", true).call();
                        return null;
                    }
                } else {
                    new IodeError("Expected a type for the variable", Stash.line, "Error", true).call();
                    return null;
                }
            } else {
                new IodeError("Expected '=' (denotes declaration) or ':' (denotes type)", Stash.line, "Error", true).call();
                return null;
            }
        } else {
            new IodeError("Expected a name for the variable", Stash.line, "Error", true).call();
            return null;
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
                    new IodeError("Expected more arguments or a ')'", Stash.line, "Error", true).call();
                    return null;
                }

                if (peekCheck(TokenType.COMMA)) {
                    nextToken(true);
                } else if (peekCheck(TokenType.RPAREN)) {
                    break;
                }
            }

            if (peekCheck(TokenType.RPAREN)) {
                nextToken();

                return new NodeCall(ident, args, Stash.line);
            } else {
                new IodeError("Expected more arguments or a ')'", Stash.line, "Error", true).call();
                return null;
            }
        } else {
            Node left = new NodeVariable(ident);
            string op = null;
            Node right = null;

            while (peekCheck(TokenType.ADD) || peekCheck(TokenType.SUB)
                || peekCheck(TokenType.MUL) || peekCheck(TokenType.DIV)) {
                skipNewline();
                op = this.nextToken().getValue();
                skipNewline();

                if (peekCheck(TokenType.NUMBER)) {
                    right = cast(NodeNumber)this.parseNumber();
                } else if (peekCheck(TokenType.DOUBLE)) {
                    right = cast(NodeDouble)this.parseDouble();
                } else if (peekCheck(TokenType.IDENT)) {
                    right = new NodeVariable(nextToken().getValue());
                } else if (peekCheck(TokenType.LPAREN)) {
                    right = this.parseParens();
                } else {
                    new IodeError("Expected a number, double, or variable after binary operation", Stash.line, "Error", true).call();
                    return null;
                }
            }

            if (op != null) {
                left = new NodeBinaryOp(left, op, right);
            }

            return left;
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
                    new IodeError("Expected more arguments or a ')'", Stash.line, "Error", true).call();
                    return null;
                }

                if (peekCheck(TokenType.COMMA)) {
                    nextToken(true);
                } else if (peekCheck(TokenType.RPAREN)) {
                    break;
                }
            }

            if (peekCheck(TokenType.RPAREN)) {
                nextToken();

                if (terminator()) {
                    nextToken(true);

                    return new NodeCall(ident, args, Stash.line);
                } else {
                    new IodeError("Expected a terminator (newline or semicolon)", Stash.line, "Error", true).call();
                    return null;
                }
            } else {
                new IodeError("Expected more arguments or a ')'", Stash.line, "Error", true).call();
                return null;
            }
        } else if (peekCheck(TokenType.EQUALS)) {
            nextToken(true);

            Node next = literal();

            if (terminator()) {
                nextToken(true);

                return new NodeSetting(ident, next);
            } else {
                new IodeError("Expected a terminator (newline or semicolon)", Stash.line, "Error", true).call();
                return null;
            }
        } else {
            new IodeError("Expected nothing, '(', or a '=' after identifier", Stash.line, "Error", true).call();
            return null;
        }
    }

    /* parses a function attribute */
    public Node parseAttribute() {
        string attr = nextToken(true).getValue();

        if (!peekCheck(TokenType.FN) && !peekCheck(TokenType.CLASS)) {
            new IodeError("Attributes only work with functions and classes, so a function/class declaration was expected", Stash.line, "Error", true).call();
            return null;
        }

        return new NodeAttribute(attr);
    }

    /* parses a function declaration */
    public Node parseFunction() {
        string attribute = "none";

        if (pos != 0) {
            if (peekSpecificCheck(TokenType.ATTRIBUTE, 0)) {
                attribute = peekSpecific(0).getValue();
            }
        }

        nextToken(true);

        if (peekCheck(TokenType.IDENT)) {
            string name = nextToken(true).getValue();

            if (peekCheck(TokenType.LPAREN)) {
                nextToken(true);
                Arg[] args;

                while (!peekCheck(TokenType.RPAREN)) {
                    if (peekCheck(TokenType.IDENT)) {
                        string argName = nextToken(true).getValue();

                        if (peekCheck(TokenType.COLON)) {
                            nextToken(true);

                            if (peekCheck(TokenType.IDENT)) {
                                string type = nextToken(true).getValue();

                                args ~= new Arg(type, argName);

                                if (peekCheck(TokenType.COMMA)) {
                                    nextToken(true);
                                } else if (peekCheck(TokenType.RPAREN)) {
                                    break;
                                } else {
                                    new IodeError("Expected more arguments or a ')'", Stash.line, "Error", true).call();
                                    return null;
                                }
                            } else {
                                new IodeError("Expected a type after ':'", Stash.line, "Error", true).call();
                                return null;
                            }
                        } else {
                            new IodeError("Expected a ':' after the parameter name", Stash.line, "Error", true).call();
                            return null;
                        }
                    } else {
                        new IodeError("Expected an identifier", Stash.line, "Error", true).call();
                        return null;
                    }
                }

                Node[] block;

                if (peekCheck(TokenType.RPAREN)) {
                    nextToken(true);

                    if (peekCheck(TokenType.GT)) {
                        nextToken(true);

                        if (peekCheck(TokenType.IDENT)) {
                            string type = nextToken().getValue();

                            if (peekCheck(TokenType.LBRACE)) {
                                nextToken(true);

                                while (!peekCheck(TokenType.RBRACE)) {
                                    block ~= startBlock();
                                    skipNewline();
                                }

                                nextToken(true);

                                return new NodeFunction(attribute, name, args, type, block);
                            } else {
                                new IodeError("Expected a '{'", Stash.line, "Error", true).call();
                                return null;
                            }
                        } else {
                            new IodeError("Expected a type", Stash.line, "Error", true).call();
                            return null;
                        }
                    } else {
                        new IodeError("Expected '>'", Stash.line, "Error", true).call();
                        return null;
                    }
                } else {
                    new IodeError("Expected ')'", Stash.line, "Error", true).call();
                    return null;
                }
            } else {
                new IodeError("Expected '('", Stash.line, "Error", true).call();
                return null;
            }
        } else {
            new IodeError("Expected a function name", Stash.line, "Error", true).call();
            return null;
        }
    }
    
    /* Parses a class */
    public Node parseClass() {
        string attribute = "none";

        if (pos != 0) {
            if (peekSpecificCheck(TokenType.ATTRIBUTE, 0)) {
                attribute = peekSpecific(0).getValue();
            }
        }

        nextToken(true);

        if (peekCheck(TokenType.IDENT)) {
            string name = nextToken(true).getValue();

            Node[] block;

            if (peekCheck(TokenType.LBRACE)) {
                nextToken(true);

                while (!peekCheck(TokenType.RBRACE)) {
                    block ~= startClass();
                    skipNewline();
                }

                nextToken(true);

                return new NodeClass(attribute, name, block);
            } else {
                new IodeError("Expected a '{'", Stash.line, "Error", true).call();
                return null;
            }
        } else {
            new IodeError("Expected a class name", Stash.line, "Error", true).call();
            return null;
        }
    }

    /* parses a return */
    public Node parseReturn() {
        nextToken(true);
        Node lit = literal();

        if (terminator()) {
            nextToken(true);
        } else {
            new IodeError("Expected a terminator (newline or semicolon)", Stash.line, "Error", true).call();
            return null;
        }

        return new NodeReturn(lit);
    }

    /* parses a newline */
    public Node parseNewline() {
        nextToken();
        Stash.line++;
        return new NodeNewline();
    }

    /* Parses a compiler command */
    public Node parseCompilerCommand() {
        Token t = nextToken(true);

        Node[] block;

        if (peekCheck(TokenType.LBRACE)) {
            nextToken(true);

            while (!peekCheck(TokenType.RBRACE)) {
                block ~= startBlock();
                skipNewline();
            }

            nextToken(true);

            return new NodeCompilerCommand(t.getValue(), block);
        } else {
            new IodeError("Expected a '{'", Stash.line, "Error", true).call();
            return null;
        }
    }

    /* Parses a parenthesis */
    public Node parseParens() {
        nextToken();
        Node left = literal();
        string op = null;
        Node right = null;

        while (peekCheck(TokenType.ADD) || peekCheck(TokenType.SUB)
            || peekCheck(TokenType.MUL) || peekCheck(TokenType.DIV)) {
            skipNewline();
            op = this.nextToken().getValue();
            skipNewline();

            if (peekCheck(TokenType.NUMBER)) {
                right = cast(NodeNumber)this.parseNumber();
            } else if (peekCheck(TokenType.DOUBLE)) {
                right = cast(NodeDouble)this.parseDouble();
            } else if (peekCheck(TokenType.IDENT)) {
                right = new NodeVariable(nextToken().getValue());
            } else if (peekCheck(TokenType.LPAREN)) {
                right = this.parseParens();
            } else {
                new IodeError("Expected a number, double, or variable after binary operation", Stash.line, "Error", true).call();
                return null;
            }
        }

        if (op != null) {
            left = new NodeBinaryOp(left, op, right);
        }

        if (peekCheck(TokenType.RPAREN)) {
            skipNewline();
            nextToken();
        } else {
            new IodeError("Expected a ')'", Stash.line, "Error", true).call();
            return null;
        }

        while (peekCheck(TokenType.ADD) || peekCheck(TokenType.SUB)
            || peekCheck(TokenType.MUL) || peekCheck(TokenType.DIV)) {
            skipNewline();
            op = this.nextToken().getValue();
            skipNewline();

            if (peekCheck(TokenType.NUMBER)) {
                right = cast(NodeNumber)this.parseNumber();
            } else if (peekCheck(TokenType.DOUBLE)) {
                right = cast(NodeDouble)this.parseDouble();
            } else if (peekCheck(TokenType.IDENT)) {
                right = new NodeVariable(nextToken().getValue());
            } else if (peekCheck(TokenType.LPAREN)) {
                right = this.parseParens();
            } else {
                new IodeError("Expected a number, double, or variable after binary operation", Stash.line, "Error", true).call();
                return null;
            }
        }

        return left;
    }

    /* gets the next literal */
    public Node literal() {
        TokenType t = peekToken().getType();

        switch (t) {
            default:
                new IodeError("Unexpected token '" ~ t ~ "'", Stash.line, "Error", true).call();
                return null;
            case TokenType.NUMBER:
                return parseNumber();
            case TokenType.DOUBLE:
                return parseDouble();
            case TokenType.BOOL:
                return parseBoolean();
            case TokenType.IDENT:
                return parseIdentLiteral();
            case TokenType.STRING:
                return parseString();
            case TokenType.NULL:
                return parseNull();
            case TokenType.LPAREN:
                return parseParens();
        }
    }

    /* gets the next statement for a class */
    public Node startClass() {
        TokenType t = peekToken().getType();

        switch (t) {
            default:
                new IodeError("Classes can't contain a '" ~ t ~ "' inside of it. Must be a variable declaration/setting or function", Stash.line, "Error", true).call();
                return null;
            case TokenType.CLASS:
                new IodeError("A class can't contain a '" ~ t ~ "' inside of it. Are you trying to create a class within a class?", Stash.line, "Error", true).call();
                return null;
            case TokenType.VAR:
                return parseDeclaration(false);
            case TokenType.LET:
                return parseDeclaration(true);
            case TokenType.FN:
                return parseFunction();
            case TokenType.ATTRIBUTE:
                return parseAttribute();
            case TokenType.NEWLINE:
                return parseNewline();
        }
    }

     /* gets the next statement for a block */
    public Node startBlock() {
        TokenType t = peekToken().getType();

        switch (t) {
            default:
                new IodeError("A block can't contain a '" ~ t ~ "' inside.", Stash.line, "Error", true).call();
                return null;
            case TokenType.CLASS:
                new IodeError("A block can't contain '" ~ t ~ "' on it's own. Are you trying to create a class within a function?", Stash.line, "Error", true).call();
                return null;
            case TokenType.VAR:
                return parseDeclaration(false);
            case TokenType.LET:
                return parseDeclaration(true);
            case TokenType.FN:
                return parseFunction();
            case TokenType.ATTRIBUTE:
                return parseAttribute();
            case TokenType.IDENT:
                return parseIdent();
            case TokenType.RETURN:
                return parseReturn();
            case TokenType.NEWLINE:
                return parseNewline();
        }
    }

    /* gets the next statement */
    public Node start() {
        TokenType t = peekToken().getType();

        switch (t) {
            default:
                new IodeError("Unexpected token '" ~ t ~ "'", Stash.line, "Error", true).call();
                return null;
            case TokenType.VAR:
                return parseDeclaration(false);
            case TokenType.LET:
                return parseDeclaration(true);
            case TokenType.FN:
                return parseFunction();
            case TokenType.CLASS:
                return parseClass();
            case TokenType.ATTRIBUTE:
                return parseAttribute();
            case TokenType.IDENT:
                return parseIdent();
            case TokenType.RETURN:
                return parseReturn();
            case TokenType.NEWLINE:
                return parseNewline();
            case TokenType.CCOMMAND:
                return parseCompilerCommand();
        }
    }
}
