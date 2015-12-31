using Iode.Library;
using System;
using System.Collections.Generic;
using System.Reflection.Emit;

namespace Iode.AST
{
    /// <summary>
    /// Represents an 'if' statement in the AST
    /// </summary>
    public class IfNode : Statement
    {
        public override NodeType type
        {
            get
            {
                return NodeType.IF;
            }
        }

        /// <summary>
        /// The value that the if statement is computing
        /// </summary>
        public Node comparison { get; set; }

        /// <summary>
        /// Code executed if true
        /// </summary>
        public List<Node> body { get; set; }

        public IfNode(Node comparison, List<Node> body)
        {
            this.comparison = comparison;
            this.body = body;
        }

        public override void generate(ILGenerator ilg)
        {
            comparison.generate(ilg);

            var toEnd = ilg.DefineLabel();
            ilg.Emit(OpCodes.Brfalse, toEnd);
            
            foreach (Node n in body)
            {
                n.generate(ilg);
            }

            ilg.MarkLabel(toEnd);
        }

        public override string ToString()
        {
            return comparison.ToString();
        }
    }
}
