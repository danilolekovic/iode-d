using System;
using System.Reflection.Emit;

namespace Iode.Methods
{
    /// <summary>
    /// Base class for a method
    /// </summary>
    public abstract class Method : IMethod
    {
        /// <summary>
        /// Name of the method
        /// </summary>
        public abstract string name { get; }

        /// <summary>
        /// Object type the method is supposed to return
        /// </summary>
        public abstract Type returnType { get; }

        /// <summary>
        /// Argument types that are supposed to be passed to the method
        /// </summary>
        public abstract Type[] types { get; }

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
