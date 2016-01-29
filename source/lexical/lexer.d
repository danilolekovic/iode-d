module iode.lexical.lexer;

import std.stdio;
import iode.lexical.token;
import std.uni;

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
        int pos = 0;
        tokens = [];
        string buffer = "";

        while (pos < code.length) {
            if (isAlpha(code[pos])) {
                while (pos < code.length && isAlpha(code[pos])) {
                    buffer ~= code[pos];
                    pos++;
                }

                tokens ~= new Token(TokenType.IDENT, buffer);

                buffer = "";
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
