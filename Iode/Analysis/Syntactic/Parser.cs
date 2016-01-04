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

            if (peekCheck(TokenType.NEWLINE) && peekToken().value != ";")
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
            if (!(totalTokens >= pos))
            {
                if (peekCheck(TokenType.NEWLINE) && peekToken().value != ";")
                {
                    line++; // new line
                }

                if (peekCheck(TokenType.NEWLINE))
                {
                    nextToken();
                }
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

                List<Expression> args = new List<Expression>();

                while (!(peekCheck(TokenType.RPAREN)))
                {
                    Expression arg = parseExpression();
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
                        throw new ParsingException("Expected a \",\" or a \")\", got a \"" + peekToken().value.ToString().ToLower() + "\"", this);
                    }
                }

                if (peekCheck(TokenType.RPAREN))
                {
                    nextToken();
                }
                else
                {
                    throw new ParsingException("Expected a \")\", got a \"" + peekToken().type.ToString().ToLower() + "\"", this);
                }

                if (peekCheck(TokenType.NEWLINE))
                {
                    skipNewline();
                }
                else
                {
                    throw new ParsingException("Expected a newline, got a \"" + peekToken().type.ToString().ToLower() + "\"", this);
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
                                    throw new ParsingException("Expected an object type of int", this);
                                }
                            }
                            else if (value.type == NodeType.NUMBER)
                            {
                            }
                            else
                            {
                                throw new ParsingException("Expected an object type of int", this);
                            }
                        }
                        else if (type == "str")
                        {
                            if (value.type == NodeType.VARIABLE)
                            {
                                VariableNode vn = (VariableNode)value;

                                if (vn.variableType != NodeType.STRING)
                                {
                                    throw new ParsingException("Expected an object type of string", this);
                                }
                            }
                            else if (value.type == NodeType.STRING)
                            {
                            }
                            else
                            {
                                throw new ParsingException("Expected an object type of string", this);
                            }
                        }
                        else if (type == "bool")
                        {
                            if (value.type == NodeType.VARIABLE)
                            {
                                bool bl = false;

                                if (!bool.TryParse(value.ToString(), out bl))
                                {
                                    throw new ParsingException("Expected an object type of boolean", this);
                                }
                            }
                            else if (value.type == NodeType.BOOLEAN)
                            {
                            }
                            else
                            {
                                throw new ParsingException("Expected an object type of boolean", this);
                            }
                        }
                    }
                    else
                    {
                        throw new ParsingException("Expected an object type", this);
                    }
                }

                if (peekCheck(TokenType.NEWLINE))
                {
                    skipNewline();
                }
                else
                {
                    throw new ParsingException("Expected a newline, got a \"" + peekToken().type.ToString().ToLower() + "\"", this);
                }

                Stash.pushVariable(ident, value);
                return new DeclarationNode(ident, value);
            }

            // Invalid token!
            else
            {
                throw new ParsingException("Expected \"(\" or \"=\" after the \"" + ident + "\"", this);
            }
        }

        /// <summary>
        /// Parses an if statement
        /// ::
        /// if (...) { ... }
        /// </summary>
        /// <returns>IfNode</returns>
        public IfNode parseIf()
        {
            nextToken();
            skipNewline();

            if (peekCheck(TokenType.LPAREN))
            {
                nextToken();
                skipNewline();

                Node condition = parseExpression();
                skipNewline();

                if (peekCheck(TokenType.RPAREN))
                {
                    nextToken();
                    skipNewline();

                    if (peekCheck(TokenType.LBRACE))
                    {
                        nextToken();
                        skipNewline();

                        List<Node> body = new List<Node>();

                        while (!peekCheck(TokenType.RBRACE))
                        {
                            var nextNode = parse();
                            skipNewline();

                            body.Add(nextNode);
                        }
                        
                        if (peekCheck(TokenType.RBRACE))
                        {
                            nextToken();
                            skipNewline();

                            return new IfNode(condition, body);
                        }
                        else
                        {
                            throw new ParsingException("Expected a \"}\"", this);
                        }
                    }
                    else
                    {
                        throw new ParsingException("Expected a \"{\"", this);
                    }
                }
                else
                {
                    throw new ParsingException("Expected a \")\"", this);
                }
            }
            else
            {
                throw new ParsingException("Expected a \"(\"", this);
            }
        }

        /// <summary>
        /// Parses mass variable declaration
        /// ::
        /// (a, b, c..) = 1, 2, 3..
        /// </summary>
        /// <returns>LongDeclarationNode</returns>
        public LongDeclarationNode parseLongDeclaration()
        {
            nextTokenNewline();
            List<string> names = parseListNames();
            skipNewline();

            if (peekCheck(TokenType.RPAREN))
            {
                nextTokenNewline();
            }
            else
            {
                throw new ParsingException("Expected \")\", got a \"" + peekToken().type.ToString().ToLower() + "\"", this);
            }

            if (peekCheck(TokenType.EQUALS))
            {
                nextTokenNewline();
            }
            else
            {
                throw new ParsingException("Expected \"=\", got a \"" + peekToken().type.ToString().ToLower() + "\"", this);
            }

            List<Node> values = parseListNodes();

            if (peekCheck(TokenType.NEWLINE))
            {
                skipNewline();
            }
            else
            {
                throw new ParsingException("Expected a newline, got a \"" + peekToken().type.ToString().ToLower() + "\"", this);
            }

            if (names.Count != values.Count)
            {
                throw new CodeGenException("Expected " + names.Count + " values, got " + values.Count);
            }

            for (int i = 0; i < names.Count; i++)
            {
                Stash.pushVariable(names[i], values[i]);
            }

            return new LongDeclarationNode(names, values);
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
                throw new ParsingException("Undefined variable \"" + ident + "\"", this);
            }
        }

        /// <summary>
        /// Parses a null object
        /// ::
        /// 'null'
        /// </summary>
        /// <returns>NullNode</returns>
        public NullNode parseNull()
        {
            nextToken();
            return new NullNode();
        }

        /// <summary>
        /// Parses a newline
        /// ::
        /// \n
        /// </summary>
        /// <returns>NewlineNode</returns>
        public NewlineNode parseNewline()
        {
            nextToken();
            return new NewlineNode();
        }

        /// <summary>
        /// Parses a list of identifiers
        /// </summary>
        /// <returns>List of identifiers</returns>
        public List<string> parseListNames()
        {
            List<string> paramList = new List<string>();

            if (peekCheck(TokenType.IDENTIFIER))
            {
                paramList.Add(nextToken().value);
                skipNewline();
            }
            else
            {
                throw new ParsingException("Expected an identifier", this);
            }

            if (peekCheck(TokenType.COMMA))
            {
                while (peekCheck(TokenType.COMMA))
                {
                    nextTokenNewline();

                    if (peekCheck(TokenType.IDENTIFIER))
                    {
                        paramList.Add(nextToken().value);
                        skipNewline();
                    }
                    else
                    {
                        throw new ParsingException("Expected an identifier", this);
                    }
                }

                return paramList;
            }
            else
            {
                throw new ParsingException("Expected a comma in the list", this);
            }
        }

        /// <summary>
        /// Parses a list of expressions
        /// </summary>
        /// <returns>List of nodes</returns>
        public List<Node> parseListNodes()
        {
            List<Node> paramList = new List<Node>();

            paramList.Add(parseExpression());
            skipNewline();

            if (peekCheck(TokenType.COMMA))
            {
                while (peekCheck(TokenType.COMMA))
                {
                    nextTokenNewline();
                    paramList.Add(parseExpression());
                    skipNewline();
                }

                return paramList;
            }
            else
            {
                throw new ParsingException("Expected a comma in the list", this);
            }
        }

        /// <summary>
        /// Parses the next expression
        /// </summary>
        /// <returns>Node</returns>
        public Expression parseExpression()
        {
            Token t = peekToken();
            Expression original;

            if (t.type == TokenType.NUMBER)
            {
                original = parseNumber();
            }
            else if (t.type == TokenType.STRING)
            {
                original = parseString();
            }
            else if (t.type == TokenType.BOOLEAN)
            {
                original = parseBoolean();
            }
            else if (t.type == TokenType.IDENTIFIER)
            {
                original = parseVariable();
            }
            else if (t.type == TokenType.NIL)
            {
                original = parseNull();
            }
            else
            {
                throw new ParsingException("Invalid token: " + t.value, this);
            }

            if (peekCheck(TokenType.ADD) || peekCheck(TokenType.SUB) || peekCheck(TokenType.DIV) || peekCheck(TokenType.MUL))
            {
                Expression left = original;
                char op = peekToken().value[0];
                Expression right = null;

                while (peekCheck(TokenType.ADD) || peekCheck(TokenType.SUB) || peekCheck(TokenType.DIV) || peekCheck(TokenType.MUL))
                {
                    op = nextToken().value[0];
                    skipNewline();
                    right = parseExpression();
                }

                return new BinaryNode(left, op, right);
            }
            else
            {
                return original;
            }
        }

        /// <summary>
        /// Parses the next method declaration argument
        /// </summary>
        /// <returns>TokenType and String</returns>
        public Dictionary<TokenType, string> parseNextArg(Dictionary<TokenType, string> orig)
        {
            Dictionary<TokenType, string> ret = orig;

            if (peekCheck(TokenType.INT) || peekCheck(TokenType.STR) || peekCheck(TokenType.BOOL))
            {
                TokenType tt = nextToken().type;

                if (peekCheck(TokenType.IDENTIFIER))
                {
                    ret.Add(tt, nextToken().value);
                    return ret;
                }
                else
                {
                    throw new ParsingException("Expected an identifier", this);
                }
            }
            else
            {
                throw new ParsingException("Expected an object type", this);
            }
        }

        /// <summary>
        /// Parses a method declaration
        /// ::
        /// def (...) { ... }
        /// </summary>
        /// <returns>MethodNode</returns>
        public MethodNode parseMethod()
        {
            nextTokenNewline();

            if (peekCheck(TokenType.IDENTIFIER))
            {
                string name = nextTokenNewline().value;

                if (peekCheck(TokenType.LPAREN))
                {
                    nextTokenNewline();
                    Dictionary<TokenType, string> args = new Dictionary<TokenType, string>();
                    TokenType retType = TokenType.VOID;
                    
                    while (!peekCheck(TokenType.RPAREN))
                    {
                        args = parseNextArg(args);
                        skipNewline();
                    }

                    if (peekCheck(TokenType.RPAREN))
                    {
                        nextTokenNewline();

                        if (peekCheck(TokenType.ARROW))
                        {
                            nextTokenNewline();

                            if (peekCheck(TokenType.INT) || peekCheck(TokenType.STR) || peekCheck(TokenType.BOOL))
                            {
                                retType = nextToken().type;
                            }
                            else
                            {
                                throw new ParsingException("Expected an object type", this);
                            }
                        }

                        if (peekCheck(TokenType.LBRACE))
                        {
                            nextTokenNewline();

                            List<Node> body = new List<Node>();

                            while (!peekCheck(TokenType.RBRACE))
                            {
                                var nextNode = parse();
                                skipNewline();

                                body.Add(nextNode);
                            }

                            if (peekCheck(TokenType.RBRACE))
                            {
                                nextTokenNewline();
                                var methodNode = new MethodNode(name, retType, args, body);
                                methodNode.generate(null);
                                return methodNode;
                            }
                            else
                            {
                                throw new ParsingException("Expected a \"}\"", this);
                            }
                        }
                        else
                        {
                            throw new ParsingException("Expected a \"{\"", this);
                        }
                    }
                    else
                    {
                        throw new ParsingException("Expected a \")\"", this);
                    }
                }
                else
                {
                    throw new ParsingException("Expected a \"(\"", this);
                }
            }
            else
            {
                throw new ParsingException("Expected a method name", this);
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
                case TokenType.IF:
                    return parseIf();
                case TokenType.DEF:
                    return parseMethod();
                case TokenType.LPAREN:
                    return parseLongDeclaration();
                case TokenType.NEWLINE:
                    return parseNewline();
                default:
                    throw new ParsingException("Invalid token: " + t.ToString(), this);
            }
        }
    }
}
