using Iode.AST;
using System;
using System.Collections.Generic;
using System.Reflection.Emit;

namespace Iode.Methods
{
    /// <summary>
    /// User-created method
    /// </summary>
    public class UserMethod : IMethod
    {
        /// <summary>
        /// Name of the method
        /// </summary>
        public string name { get; set; }

        /// <summary>
        /// Object type the method is supposed to return
        /// </summary>
        public Type returnType { get; set; }

        /// <summary>
        /// Argument types that are supposed to be passed to the method
        /// </summary>
        public Type[] types { get; set; }

        /// <summary>
        /// Code inside the method
        /// </summary>
        public List<Node> body { get; set; }

        /// <summary>
        /// List of param names
        /// </summary>
        public List<string> names { get; set; }

        public UserMethod(string name, Type returnType, Type[] types, List<Node> body, List<string> names)
        {
            this.name = name;
            this.returnType = returnType;
            this.types = types;
            this.body = body;
            this.names = names;
        }

        /// <summary>
        /// Creates a DynamicMethod
        /// </summary>
        /// <returns>DynamicMethod</returns>
        public DynamicMethod getDynamicMethod()
        {
            return new DynamicMethod(name, returnType, types);
        }
    }
}
