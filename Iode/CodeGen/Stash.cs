using Iode.AST;
using System.Collections.Generic;
using System.Linq;

namespace Iode.CodeGen
{
    /// <summary>
    /// Contains variable lists and such
    /// </summary>
    public class Stash
    {
        public static Dictionary<string, Node> variables = new Dictionary<string, Node>();

        /// <summary>
        /// Checks if the specified variable has been declared yet
        /// </summary>
        /// <param name="name">Variable name</param>
        /// <returns>Boolean</returns>
        public static bool variableExists(string name)
        {
            return variables.Keys.Contains(name);
        }

        /// <summary>
        /// Deletes the specified variable
        /// </summary>
        /// <param name="name">Variable name</param>
        public static void deleteVariable(string name)
        {
            variables.Remove(name);
        }

        /// <summary>
        /// Creates a new variable
        /// </summary>
        /// <param name="name">Variable name</param>
        /// <param name="value">Variable value</param>
        public static void pushVariable(string name, Node value)
        {
            // not going to use variables.add(.., ..);
            variables[name] = value;
        }

        /// <summary>
        /// Gets the value of the specified variable
        /// </summary>
        /// <param name="name"></param>
        /// <returns></returns>
        public static Node getVariable(string name)
        {
            return variables[name];
        }
    }
}
