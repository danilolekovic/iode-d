module iode.lexical.token;

import std.stdio;

/* Token that the parser can understand */
class Token {
    // Type of token
    private TokenType tokenType;

    // Token's value in the code
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

/* Legal token types */
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
    NEWLINE,

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
    IF,
    FN,
    VAR,
    LET,
    TYPE
}
