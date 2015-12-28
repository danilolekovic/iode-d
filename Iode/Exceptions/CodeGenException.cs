using System;
using System.Runtime.Serialization;

namespace Iode.Exceptions
{
    /// <summary>
    /// Exception called during an AST error
    /// </summary>
    public class CodeGenException : Exception
    {
        public CodeGenException(string message) : base(message)
        {
        }

        public CodeGenException(string message, Exception innerException) : base(message, innerException)
        {
        }

        protected CodeGenException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}
