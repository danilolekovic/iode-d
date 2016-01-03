using Iode.Analysis.Lexical;
using Iode.CodeGen;
using Iode.Methods;
using System;
using System.Collections.Generic;
using System.Reflection.Emit;

namespace Iode.AST
{
    public class MethodNode : Node
    {
        public override NodeType type
        {
            get
            {
                return NodeType.METHOD;
            }
        }

        /// <summary>
        /// Name of the method
        /// </summary>
        public string name { get; set; }

        /// <summary>
        /// Object type the method is supposed to return
        /// </summary>
        public TokenType returnType { get; set; }

        /// <summary>
        /// Argument types and names that are supposed to be passed to the method
        /// </summary>
        public Dictionary<TokenType, string> types { get; set; }

        /// <summary>
        /// Code inside the method
        /// </summary>
        public List<Node> body { get; set; }

        public MethodNode(string name, TokenType returnType, Dictionary<TokenType, string> types, List<Node> body)
        {
            this.name = name;
            this.returnType = returnType;
            this.types = types;
            this.body = body;
        }

        public override void generate(ILGenerator ilg)
        {
            Type realReturnType = typeof(void);

            switch (returnType)
            {
                case TokenType.INT:
                    realReturnType = typeof(double);
                    break;
                case TokenType.STR:
                    realReturnType = typeof(string);
                    break;
                case TokenType.BOOL:
                    realReturnType = typeof(bool);
                    break;
                case TokenType.VOID:
                    realReturnType = typeof(void);
                    break;
                default:
                    realReturnType = typeof(void);
                    break;
            }

            List<Type> realTypes = new List<Type>();

            foreach (TokenType t in types.Keys)
            {
                switch (t)
                {
                    case TokenType.INT:
                        realTypes.Add(typeof(double));
                        break;
                    case TokenType.STR:
                        realTypes.Add(typeof(string));
                        break;
                    case TokenType.BOOL:
                        realTypes.Add(typeof(bool));
                        break;
                    case TokenType.VOID:
                        realTypes.Add(typeof(void));
                        break;
                    default:
                        realTypes.Add(typeof(void));
                        break;
                }
            }

            List<string> names = new List<string>(types.Values);
            UserMethod um = new UserMethod(name, realReturnType, realTypes.ToArray(), body, names);
            Stash.pushMethod(um);
        }

        public override string ToString()
        {
            return name;
        }
    }
}
