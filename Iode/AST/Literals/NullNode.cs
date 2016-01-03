using System;
using System.Reflection.Emit;

namespace Iode.AST
{
    /// <summary>
    /// Represents a null object in the AST
    /// </summary>
    public class NullNode : Expression
    {
        public override NodeType type
        {
            get
            {
                return NodeType.NULL;
            }
        }

        public override void generate(ILGenerator ilg)
        {
            ilg.Emit(OpCodes.Ldnull);
        }

        public override string ToString()
        {
            return null;
        }
    }
}
