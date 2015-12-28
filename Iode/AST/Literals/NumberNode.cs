using System;
using System.Reflection.Emit;

namespace Iode.AST
{
    /// <summary>
    /// Represents a number ([0-9]+) in the AST
    /// </summary>
    public class NumberNode : Expression
    {
        public override NodeType type
        {
            get
            {
                return NodeType.NUMBER;
            }
        }

        // Number value
        public double value { get; set; }

        public NumberNode(double value)
        {
            this.value = value;
        }

        public override void generate(ILGenerator ilg)
        {
            ilg.Emit(OpCodes.Ldind_I4, value);
        }

        public override string ToString()
        {
            return value.ToString();
        }
    }
}
