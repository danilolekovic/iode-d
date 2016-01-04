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
        /// ToString() method
        /// </summary>
        /// <returns>Stringified value</returns>
        public abstract override string ToString();

        /// <summary>
        /// Calls code generation
        /// </summary>
        public abstract void generate(ILGenerator ilg);
    }

    public abstract class Expression : Node
    {
        /// <summary>
        /// Value
        /// </summary>
        public abstract dynamic value { get; }
    }

    public abstract class Statement : Node
    {
    }
}
