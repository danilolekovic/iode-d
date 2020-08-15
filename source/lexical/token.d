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
enum TokenType : string {
    // types
    IDENT = "identifier",
    STRING = "string",
    NUMBER = "number",
    DOUBLE = "double",
    BOOL = "boolean",
    NULL = "null",

    // symbols
    COMMA = "comma",
    DOT = "dot",
    COLON = "colon",
    NEWLINE = "terminator",
    LPAREN = "left parenthesis",
    RPAREN = "right parenthesis",
    LBRACE = "left brace",
    RBRACE = "right brace",
    SEMICOLON = "semicolon",
    ATTRIBUTE = "attribute",

    // math
    ADD = "add",
    DIV = "divide",
    MUL = "multiply",
    SUB = "subtract",
    MOD = "modulus",
    GT = "greater-than",
    LT = "less-than",
    GTE = "greater-than-equal-to",
    LTE = "less-than-equal-to",
    EQUALS = "equals",

    // keywords
    IF = "if",
    FN = "function",
    VAR = "variable",
    LET = "constant variable",
    RETURN = "return",
    TYPE = "type",
    CLASS = "class",

    // special
    CCOMMAND = "compiler command"
}
