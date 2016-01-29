module iode.lexical.lexer;

import std.stdio;
import iode.lexical.token;
import std.uni;

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
                final switch (buffer) {
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
            } else if (code[pos] == '\n') {
                tokens ~= new Token(TokenType.NEWLINE, "\n");
                pos++;
            } else if (isWhite(code[pos])) {
                // ignore whitespace
                pos++;
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
