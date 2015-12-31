using System;
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
        /// Creates a DynamicMethod
        /// </summary>
        /// <returns>DynamicMethod</returns>
        public DynamicMethod getDynamicMethod()
        {
            return new DynamicMethod(name, returnType, types);
        }
    }
}
