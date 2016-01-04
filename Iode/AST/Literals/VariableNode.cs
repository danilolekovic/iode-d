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

        /// <summary>
        /// Name of the variable
        /// </summary>
        public string name { get; set; }

        /// <summary>
        /// Type of value
        /// </summary>
        public NodeType variableType { get; set; }

        public override dynamic value
        {
            get
            {
                return Stash.getVariable(name).value;
            }
        }

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
