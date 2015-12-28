using Iode.Analysis.Lexical;
using Iode.AST;
using Iode.CodeGen;
using Iode.Exceptions;
using System;
using System.Collections.Generic;

namespace Iode.Analysis.Syntactic
{
    /// <summary>
    /// Turns tokens into an abstract syntax tree
    /// </summary>
    public class Parser
    {
        /// <summary>
        /// Current position in the list of tokens
        /// </summary>
        public int pos { get; set; }

        /// <summary>
        /// Current line #
        /// </summary>
        public int line { get; set; }

        /// <summary>
        /// Total number of tokens from the lexer
        /// </summary>
        public int totalTokens { get; set; }

        /// <summary>
        /// Expected at the end of every statement
        /// </summary>
        public TokenType TERMINATOR { get; set; }

        /// <summary>
        /// The lexer
        /// </summary>
        public Lexer lexer { get; set; }

        public Parser(Lexer lexer)
        {
            this.lexer = lexer;
            this.pos = 0;
            this.line = 1;
            this.TERMINATOR = TokenType.NEWLINE;
            this.totalTokens = lexer.tokens.Count;
        }

        /// <summary>
        /// Looks ahead one token
        /// </summary>
        /// <returns>Next token</returns>
        public Token peekToken()
        {
            return lexer.peekToken();
        }

        /// <summary>
        /// Checks if the next token is a (type)
        /// </summary>
        /// <param name="type"></param>
        /// <returns>Next token</returns>
        public bool peekCheck(TokenType type)
        {
            return peekToken().type == type;
        }

        /// <summary>
        /// Checks if a certain token is a (type)
        /// </summary>
        /// <param name="type"></param>
        /// <returns>Certain token</returns>
        public bool peekSpecificCheck(TokenType type, int i)
        {
            return peekSpecific(i).type == type;
        }

        /// <summary>
        /// Looks ahead (i) tokens
        /// </summary>
        /// <param name="i"></param>
        /// <returns>Next token</returns>
        public Token peekSpecific(int i)
        {
            return lexer.peekSpecific(i);
        }

        /// <summary>
        /// Returns next token
        /// </summary>
        /// <returns>Next token</returns>
        public Token nextToken()
        {
            pos++;

            if (peekCheck(TokenType.NEWLINE))
            {
                line++;
            }

            return lexer.nextToken();
        }

        /// <summary>
        /// Skips the upcoming newline
        /// </summary>
        public void skipNewline()
        {
            if (peekCheck(TokenType.NEWLINE))
            {
                line++; // new line
                nextToken();
            }
        }

        /// <summary>
        /// Performs functions of skipNewline() and nextToken()
        /// </summary>
        /// <returns>Next token</returns>
        public Token nextTokenNewline()
        {
            Token toReturn = nextToken();
            skipNewline();
            return toReturn;
        }

        // Nodes

        /// <summary>
        /// Parses a number
        /// ::
        /// [0-9]+
        /// </summary>
        /// <returns>Number Node</returns>
        public NumberNode parseNumber()
        {
            // convert token string to a double
            return new NumberNode(double.Parse(nextToken().value));
        }

        /// <summary>
        /// Parses a string
        /// ::
        /// " .* "
        /// </summary>
        /// <returns>String Node</returns>
        public StringNode parseString()
        {
            return new StringNode(nextToken().value);
        }

        /// <summary>
        /// Parses a boolean
        /// ::
        /// true | false
        /// </summary>
        /// <returns>Boolean Node</returns>
        public BooleanNode parseBoolean()
        {
            // convert token string to a boolean
            return new BooleanNode(bool.Parse(nextToken().value));
        }

        /// <summary>
        /// Parses a variable declaration
        /// ::
        /// var [name] = [value]
        /// </summary>
        /// <returns>DeclarationNode</returns>
        public DeclarationNode parseDeclaration()
        {
            // eat up "var"
            nextToken();
            skipNewline();

            // check for a name
            if (peekCheck(TokenType.IDENTIFIER))
            {
                string name = nextToken().getValue();
                skipNewline();

                // check for an equals sign
                if (peekCheck(TokenType.EQUALS))
                {
                    nextToken();
                    skipNewline();

                    Node value = parseExpression();

                    if (peekCheck(TokenType.NEWLINE))
                    {
                        skipNewline();

                        return new DeclarationNode(name, value);
                    }
                    else
                    {
                        throw new ParsingException("Expected a newline, got a \"" + peekToken().type.ToString().ToLower() + "\"", line);
                    }
                }
                else
                {
                    throw new ParsingException("Expected \"=\", got a \"" + peekToken().type.ToString().ToLower() + "\"", line);
                }
            }
            else
            {
                throw new ParsingException("Expected a variable name, got a \"" + peekToken().type.ToString().ToLower() + "\"", line);
            }
        }

        /// <summary>
        /// Parses an identifier
        /// ::
        /// [ident] = [value]
        /// [ident](expr*(,)?)
        /// </summary>
        /// <returns>CallNode or DeclarationNode</returns>
        public Node parseIdentifier()
        {
            // fetches the identifier
            string ident = nextToken().value;

            // Function call!
            if (peekCheck(TokenType.LPAREN))
            {
                skipNewline();
                nextToken();
                skipNewline();

                List<Node> args = new List<Node>();

                while (!(peekCheck(TokenType.RPAREN)))
                {
                    Node arg = parseExpression();
                    skipNewline();

                    args.Add(arg);

                    if (peekCheck(TokenType.COMMA))
                    {
                        nextTokenNewline();
                    }
                    else if (peekCheck(TokenType.RPAREN))
                    {
                        break;
                    }
                    else
                    {
                        throw new ParsingException("Expected a \",\" or a \")\", got a \"" + peekToken().type.ToString().ToLower() + "\"", line);
                    }
                }

                if (peekCheck(TokenType.RPAREN))
                {
                    nextToken();
                }
                else
                {
                    throw new ParsingException("Expected a \")\", got a \"" + peekToken().type.ToString().ToLower() + "\"", line);
                }

                if (peekCheck(TokenType.NEWLINE))
                {
                    skipNewline();
                }
                else
                {
                    throw new ParsingException("Expected a newline, got a \"" + peekToken().type.ToString().ToLower() + "\"", line);
                }

                return new CallNode(ident, args);
            }

            // Variable declaration!
            else if (peekCheck(TokenType.EQUALS))
            {
                skipNewline();
                nextToken();
                skipNewline();
                Node value = parseExpression();

                if (peekCheck(TokenType.ARROW))
                {
                    nextToken();
                    skipNewline();

                    if (peekCheck(TokenType.INT) || peekCheck(TokenType.STR) || peekCheck(TokenType.BOOL))
                    {
                        string type = nextToken().value;

                        if (type == "int")
                        {
                            if (value.type == NodeType.VARIABLE)
                            {
                                double dbl = 0;

                                if (!double.TryParse(value.ToString(), out dbl))
                                {
                                    throw new ParsingException("Expected an object type of int", line);
                                }
                            }
                            else if (value.type == NodeType.NUMBER)
                            {
                            }
                            else
                            {
                                throw new ParsingException("Expected an object type of int", line);
                            }
                        }
                        else if (type == "str")
                        {
                            // todo
                        }
                        else if (type == "bool")
                        {
                            if (value.type == NodeType.VARIABLE)
                            {
                                bool bl = false;

                                if (!bool.TryParse(value.ToString(), out bl))
                                {
                                    throw new ParsingException("Expected an object type of boolean", line);
                                }
                            }
                            else if (value.type == NodeType.BOOLEAN)
                            {
                            }
                            else
                            {
                                throw new ParsingException("Expected an object type of boolean", line);
                            }
                        }
                    }
                    else
                    {
                        throw new ParsingException("Expected an object type", line);
                    }
                }

                if (peekCheck(TokenType.NEWLINE))
                {
                    skipNewline();
                }
                else
                {
                    throw new ParsingException("Expected a newline, got a \"" + peekToken().type.ToString().ToLower() + "\"", line);
                }

                return new DeclarationNode(ident, value);
            }

            // Invalid token!
            else
            {
                throw new ParsingException("Expected \"(\" or \"=\" after the \"" + ident + "\"", line);
            }
        }

        /// <summary>
        /// Parses a variable
        /// ::
        /// [A-Za-z][A-Za-z0-9]*
        /// </summary>
        /// <returns>VariableNode</returns>
        public VariableNode parseVariable()
        {
            // fetches the identifier
            string ident = nextToken().value;

            // Checking if the variable exists
            if (Stash.variableExists(ident))
            {
                return new VariableNode(ident);
            }
            else
            {
                throw new ParsingException("Undefined variable \"" + ident + "\"", line);
            }
        }

        /// <summary>
        /// Parses the next expression
        /// </summary>
        /// <returns>Node</returns>
        public Node parseExpression()
        {
            TokenType t = peekToken().type;

            switch (t)
            {
                case TokenType.NUMBER:
                    return parseNumber();
                case TokenType.STRING:
                    return parseString();
                case TokenType.BOOLEAN:
                    return parseBoolean();
                case TokenType.IDENTIFIER:
                    return parseVariable();
                default:
                    throw new ParsingException("Invalid token: " + t.ToString(), line);
            }
        }

        /// <summary>
        /// Parses the next statement
        /// </summary>
        /// <returns>Node</returns>
        public Node parse()
        {
            TokenType t = peekToken().type;

            // Check the type of token and decide how to parse it
            switch (t)
            {
                case TokenType.IDENTIFIER:
                    return parseIdentifier();
                default:
                    throw new ParsingException("Invalid token: " + t.ToString(), line);
            }
        }
    }
}
