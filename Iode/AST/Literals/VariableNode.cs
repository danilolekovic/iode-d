using Iode.CodeGen;
using System.Reflection.Emit;
using System;

namespace Iode.AST
{
    /// <summary>
    /// Represents an identifier with a value in the AST
    /// </summary>
    public class VariableNode : Expression
    {
        public override NodeType type
        {
            get
            {
                return NodeType.VARIABLE;
            }
        }

        // Name of the variable
        public string name { get; set; }

        // Type of value
        public NodeType variableType { get; set; }

        public VariableNode(string name)
        {
            this.name = name;
            this.variableType = Stash.getVariable(name).type;
        }

        public override void generate(ILGenerator ilg)
        {
            Stash.getVariable(name).generate(ilg);
        }

        public override string ToString()
        {
            return Stash.getVariable(name).ToString();
        }
    }
}
