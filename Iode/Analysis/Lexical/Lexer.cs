using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Iode.Analysis.Lexical
{
    /// <summary>
    /// Takes input code, outputs tokens that
    /// the parser can understand
    /// </summary>
    public class Lexer
    {
        /// <summary>
        /// The input code
        /// </summary>
        public string code { get; set; }

        /// <summary>
        /// Current position in the code
        /// </summary>
        public int index { get; set; }

        /// <summary>
        /// Lexer output
        /// </summary>
        public List<Token> tokens { get; set; }

        /// <summary>
        /// Current line number
        /// </summary>
        public int line { get; set; }

        public Lexer(string code)
        {
            this.code = code;
            this.index = -1;
            this.tokens = new List<Token>();
            this.line = 1;
        }

        /// <summary>
        /// Looks ahead one token
        /// </summary>
        /// <returns>Next token</returns>
        public Token peekToken()
        {
            return tokens[index + 1];
        }

        /// <summary>
        /// Looks ahead (i) tokens
        /// </summary>
        /// <param name="i"></param>
        /// <returns>Specific token</returns>
        public Token peekSpecific(int i)
        {
            return tokens[index + i];
        }

        /// <summary>
        /// Eats the next token
        /// </summary>
        /// <returns>Next token</returns>
        public Token nextToken()
        {
            index++;
            return tokens[index];
        }

        /// <summary>
        /// Converts code to tokens
        /// </summary>
        public void tokenize()
        {
            int pos = 0;
            tokens.Clear(); // make sure that the output list is empty

            // while there is still code..
            while (pos < code.Length) // checks if char is a letter
            {
                string str = ""; // buffer for values

                // checking if the char is a letter
                if (char.IsLetter(code[pos]) || code[pos] == '_')
                {
                    str += code[pos]; // append char to buffer
                    pos++; // move on to the next char

                    // now we're checking if the char is a letter OR digit
                    while (pos < code.Length && (char.IsLetterOrDigit(code[pos]) || code[pos] == '_'))
                    {
                        str += code[pos];
                        pos++;
                    }

                    // checking for keywords; if it's not a special keyword,
                    // it is an identifier.

                    if (str == "if")
                    {
                        tokens.Add(new Token(TokenType.IF, str)); // push to tokens list
                    }
                    else if (str == "else")
                    {
                        tokens.Add(new Token(TokenType.ELSE, str));
                    }
                    else if (str == "def")
                    {
                        tokens.Add(new Token(TokenType.FUNCTION, str));
                    }

                    // checking for bools and nil values
                    else if (str == "true" || str == "false")
                    {
                        tokens.Add(new Token(TokenType.BOOLEAN, str));
                    }
                    else if (str == "nil")
                    {
                        tokens.Add(new Token(TokenType.NIL, str));
                    }

                    // checking for types
                    else if (str == "string")
                    {
                        tokens.Add(new Token(TokenType.STR, str));
                    }
                    else if (str == "bool")
                    {
                        tokens.Add(new Token(TokenType.BOOL, str));
                    }
                    else if (str == "int")
                    {
                        tokens.Add(new Token(TokenType.INT, str));
                    }

                    // must be an identifier
                    else
                    {
                        tokens.Add(new Token(TokenType.IDENTIFIER, str));
                    }

                    str = ""; // reset buffer
                }

                // checking if the char is a number
                else if (char.IsDigit(code[pos]))
                {
                    str += code[pos];
                    pos++;

                    while (pos < code.Length && char.IsDigit(code[pos]))
                    {
                        str += code[pos];
                        pos++;
                    }

                    tokens.Add(new Token(TokenType.NUMBER, str));

                    str = "";
                }
                // checking of the char is a quote
                else if (code[pos] == '"')
                {
                    pos++;

                    while (pos < code.Length && code[pos] != '"')
                    {
                        str += code[pos];
                        pos++;
                    }

                    pos++;
                    tokens.Add(new Token(TokenType.STRING, str));

                    str = "";
                }

                // checking for whitespace & newlines
                else if (code[pos] == '\n' || code[pos] == ';')
                {
                    line++;
                    pos++;
                    tokens.Add(new Token(TokenType.NEWLINE, code[pos].ToString()));
                }
                else if (char.IsWhiteSpace(code[pos]))
                {
                    pos++; // ignore whitespace
                }

                // checking for operators & symbols
                else if (code[pos] == '+')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.ADD, "+"));
                }
                else if (code[pos] == '-')
                {
                    pos++;
                    
                    if (code[pos] == '>')
                    {
                        pos++;
                        tokens.Add(new Token(TokenType.ARROW, "->"));
                    }
                    else
                    {
                        tokens.Add(new Token(TokenType.SUB, "-"));
                    }
                }
                else if (code[pos] == '*')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.MUL, "*"));
                }
                else if (code[pos] == '/')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.DIV, "/"));
                }
                else if (code[pos] == '.')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.DOT, "."));
                }
                else if (code[pos] == ',')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.COMMA, ","));
                }
                else if (code[pos] == '(')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.LPAREN, "("));
                }
                else if (code[pos] == ')')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.RPAREN, ")"));
                }
                else if (code[pos] == '{')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.LBRACE, "{"));
                }
                else if (code[pos] == '}')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.RBRACE, "}"));
                }
                else if (code[pos] == '[')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.LBRACK, "["));
                }
                else if (code[pos] == ']')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.RBRACK, "]"));
                }
                else if (code[pos] == '=')
                {
                    pos++;
                    tokens.Add(new Token(TokenType.EQUALS, "="));
                }
            }
        }
    }
}
