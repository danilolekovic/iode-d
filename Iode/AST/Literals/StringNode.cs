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

        /// <summary>
        /// String value
        /// </summary>
        public string _value { get; set; }

        public override dynamic value
        {
            get
            {
                return _value;
            }
        }

        public StringNode(string value)
        {
            this._value = value;
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
