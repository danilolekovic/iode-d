module iode.lexical.lexer;

import std.stdio;
import std.uni;
import iode.lexical.token;
import iode.errors.lexerError;

/* Converts raw code into tokens */
class Lexer {
    private string code;
    private int index;
    public Token[] tokens;
    private int line;

    this(string code) {
        this.code = code;
        this.index = -1;
        this.tokens = [];
    }

    /* Converts code into tokens */
    public void tokenize() {
        // current position in the code
        int pos = 0;

        // output
        tokens = [];

        // buffer of current load
        string buffer = "";

        while (pos < code.length) {
            if (isAlpha(code[pos])) {
                // identifier..

                while (pos < code.length && isAlpha(code[pos])) {
                    buffer ~= code[pos]; // append to buffer..
                    pos++;
                }

                // defaultly expecting identifier
                TokenType theType = TokenType.IDENT;

                // check for keywords..
                switch (buffer) {
                    default:
                        theType = TokenType.IDENT;
                        break;
                    case "if":
                        theType = TokenType.IF;
                        break;
                    case "fn":
                        theType = TokenType.FN;
                        break;
                    case "var":
                        theType = TokenType.VAR;
                        break;
                    case "let":
                        theType = TokenType.LET;
                        break;
                    case "true":
                    case "false":
                        theType = TokenType.BOOL;
                        break;
                    case "null":
                        theType = TokenType.NULL;
                        break;
                }

                // push token
                tokens ~= new Token(theType, buffer);
                buffer = ""; // reset buffer
            } else if (isNumber(code[pos])) {
                // number..
                while (pos < code.length && isNumber(code[pos])) {
                    buffer ~= code[pos];
                    pos++;
                }

                tokens ~= new Token(TokenType.NUMBER, buffer);
                buffer = "";
            } else if (code[pos] == '\"') {
                // string..

                // remove quote
                pos++;

                while (pos < code.length && code[pos] != '\"') {
                    buffer ~= code[pos];
                    pos++;
                }

                tokens ~= new Token(TokenType.STRING, buffer);
                buffer = "";

                // remove quote
                pos++;
            } else if (code[pos] == '\n') {
                tokens ~= new Token(TokenType.NEWLINE, "\n");
                pos++;
            } else if (isWhite(code[pos])) {
                // ignore whitespace
                pos++;
            } else {
                string toStr = "";
                toStr ~= code[pos];

                switch (code[pos]) {
                    default:
                        throw new LexerException("Illegal symbol: " ~ toStr, line);
                    case '+':
                        tokens ~= new Token(TokenType.ADD, toStr);
                        pos++;
                        break;
                    case '-':
                        tokens ~= new Token(TokenType.SUB, toStr);
                        pos++;
                        break;
                    case '*':
                        tokens ~= new Token(TokenType.MUL, toStr);
                        pos++;
                        break;
                    case '/':
                        tokens ~= new Token(TokenType.DIV, toStr);
                        pos++;
                        break;
                    case ':':
                        tokens ~= new Token(TokenType.COLON, toStr);
                        pos++;
                        break;
                    case '.':
                        tokens ~= new Token(TokenType.DOT, toStr);
                        pos++;
                        break;
                    case '#':
                        pos++;

                        while (code[pos] != '#') {
                            pos++;
                        }

                        pos++;
                        break;
                    case '%':
                        tokens ~= new Token(TokenType.MOD, toStr);
                        pos++;
                        break;
                    case '>':
                        pos++;

                        if (code.length < (pos + 1) && code[pos + 1] == '=') {
                            pos++;
                            tokens ~= new Token(TokenType.LTE, toStr);
                        } else {
                            tokens ~= new Token(TokenType.LT, toStr);
                        }
                        break;
                    case '<':
                        pos++;

                        if (code.length < (pos + 1) && code[pos + 1] == '=') {
                            pos++;
                            tokens ~= new Token(TokenType.LTE, toStr);
                        } else {
                            tokens ~= new Token(TokenType.LT, toStr);
                        }
                        break;
                    case '=':
                        tokens ~= new Token(TokenType.EQUALS, toStr);
                        pos++;
                        break;
                    case '(':
                        tokens ~= new Token(TokenType.LPAREN, toStr);
                        pos++;
                        break;
                    case ')':
                        tokens ~= new Token(TokenType.RPAREN, toStr);
                        pos++;
                        break;
                }
            }
        }
    }

    public Token peekToken() {
        return tokens[index + 1];
    }

    public Token peekSpecific(int i) {
        return tokens[index + i];
    }

    public Token nextToken() {
        index++;
        return tokens[index];
    }
}
