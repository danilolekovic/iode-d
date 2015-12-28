using System;
using System.Reflection.Emit;

namespace Iode.AST
{
    /// <summary>
    /// Represents a string (".*") in the AST
    /// </summary>
    public class StringNode : Expression
    {
        public override NodeType type
        {
            get
            {
                return NodeType.STRING;
            }
        }

        // String value
        public string value { get; set; }

        public StringNode(string value)
        {
            this.value = value;
        }

        public override void generate(ILGenerator ilg)
        {
            ilg.Emit(OpCodes.Ldstr, value);
        }

        public override string ToString()
        {
            return value;
        }
    }
}
