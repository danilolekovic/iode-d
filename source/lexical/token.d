module iode.lexical.token;

import std.stdio;

class Token {
    private TokenType tokenType;
    private string value;

    this(TokenType tokenType, string value) {
        this.tokenType = tokenType;
        this.value = value;
    }

    public TokenType getType() {
        return this.tokenType;
    }

    public string getValue() {
        return this.value;
    }
}

enum TokenType {
    // types
    IDENT,
    STRING,
    NUMBER,
    BOOL,

    // symbols
    COMMA,
    DOT,
    HASHTAG,
    COLON,

    // math
    ADD,
    DIV,
    MUL,
    SUB,
    MOD,
    GT,
    LT,
    GTE,
    LTE,

    // keywords
    FN,
    VAR,
    LET,
    TYPE
}
