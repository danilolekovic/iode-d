using Iode.CodeGen;
using Iode.Exceptions;
using System.Collections.Generic;
using System.Reflection.Emit;

namespace Iode.AST
{
    /// <summary>
    /// Represents a mass variable declaration in the AST
    /// </summary>
    public class LongDeclarationNode : Node
    {
        public override NodeType type
        {
            get
            {
                return NodeType.DECLARATION;
            }
        }

        /// <summary>
        /// All variable names
        /// </summary>
        public List<string> names { get; set; }

        /// <summary>
        /// All variable values
        /// </summary>
        public List<Expression> values { get; set; }

        public LongDeclarationNode(List<string> names, List<Expression> values)
        {
            this.names = names;
            this.values = values;
        }

        public override void generate(ILGenerator ilg)
        {
        }

        public override string ToString()
        {
            return names.ToArray().ToString();
        }
    }
}
