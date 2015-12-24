using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Iode.Analysis.Lexical
{
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

        // Keywords
        IF,
        ELSE,
        FUNCTION,
        VAR,

        // Special
        NEWLINE
    }
}
