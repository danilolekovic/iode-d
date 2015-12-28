namespace Iode.Analysis.Lexical
{
    /// <summary>
    /// All possible tokens
    /// </summary>
    public enum TokenType
    {
        // Types
        IDENTIFIER,
        NUMBER,
        BOOLEAN,
        STRING,
        NIL,

        // Mathematical
        ADD,
        SUB,
        MUL,
        DIV,

        // Syntactical
        COMMA,
        DOT,
        LPAREN,
        RPAREN,
        LBRACE,
        RBRACE,
        LBRACK,
        RBRACK,
        EQUALS,

        // Keywords
        IF,
        ELSE,
        FUNCTION,
        VAR,

        // Special
        NEWLINE
    }
}
