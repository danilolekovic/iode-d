using System.Reflection.Emit;

namespace Iode.AST
{
    /// <summary>
    /// A branch in the AST
    /// </summary>
    public abstract class Node
    {
        /// <summary>
        /// The type of node
        /// </summary>
        public abstract NodeType type { get; }

        /// <summary>
        /// Calls code generation
        /// </summary>
        public abstract void generate(ILGenerator ilg);
    }

    public abstract class Expression : Node
    {
    }

    public abstract class Statement : Node
    {
    }
}
