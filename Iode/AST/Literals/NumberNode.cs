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

        /// <summary>
        /// Double value
        /// </summary>
        public double _value { get; set; }

        public override dynamic value
        {
            get
            {
                return _value;
            }
        }

        public NumberNode(double value)
        {
            this._value = value;
        }

        public override void generate(ILGenerator ilg)
        {
            ilg.Emit(OpCodes.Ldc_I4, value);
        }

        public override string ToString()
        {
            return value.ToString();
        }
    }
}
