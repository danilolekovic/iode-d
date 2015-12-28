using System;
using System.Reflection.Emit;

namespace Iode.AST
{
    /// <summary>
    /// Represents a boolean (true|false) in the AST
    /// </summary>
    public class BooleanNode : Expression
    {
        public override NodeType type
        {
            get
            {
                return NodeType.BOOLEAN;
            }
        }

        // Boolean value
        public bool value { get; set; }

        public BooleanNode(bool value)
        {
            this.value = value;
        }

        public override void generate(ILGenerator ilg)
        {
            if (value)
            {
                // return boolean integer value
                ilg.Emit(OpCodes.Ldc_I4_1);
            }
            else
            {
                // since booleans are represented by 0 and 1
                ilg.Emit(OpCodes.Ldc_I4_0);
            }
        }

        public override string ToString()
        {
            return value.ToString();
        }
    }
}
