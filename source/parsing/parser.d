module iode.parsing.parser;

import std.stdio;
import iode.lexical.lexer;
import iode.lexical.token;

/* Converts tokens into AST */
class Parser {
    private Lexer lexer;
    private int pos;
    private int line;
    private ulong totalTokens;

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
}
