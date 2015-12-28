using Iode.CodeGen;
using Iode.Exceptions;
using System.Reflection.Emit;
using System;

namespace Iode.AST
{
    /// <summary>
    /// Represents a variable declaration in the AST
    /// </summary>
    public class DeclarationNode : Node
    {
        public override NodeType type
        {
            get
            {
                return NodeType.DECLARATION;
            }
        }

        /// <summary>
        /// Name of the variable
        /// </summary>
        public string name { get; set; }

        /// <summary>
        /// Value of the variable
        /// </summary>
        public Node value { get; set; }

        public DeclarationNode(string name, Node value)
        {
            this.name = name;
            this.value = value;
        }

        public override void generate(ILGenerator ilg)
        {
            Stash.pushVariable(name, value);
        }

        public override string ToString()
        {
            return value.ToString();
        }
    }
}
