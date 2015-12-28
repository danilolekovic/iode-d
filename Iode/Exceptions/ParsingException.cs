using System;
using System.Runtime.Serialization;

namespace Iode.Exceptions
{
    /// <summary>
    /// Exception thrown during a parsing error
    /// </summary>
    public class ParsingException : Exception
    {
        public int line = 0;

        public ParsingException(string message, int line) : base(message)
        {
            this.line = line;
        }

        public ParsingException(string message, Exception innerException, int line) : base(message, innerException)
        {
            this.line = line;
        }

        protected ParsingException(SerializationInfo info, StreamingContext context, int line) : base(info, context)
        {
            this.line = line;
        }

        public override string Message
        {
            get
            {
                return base.Message + " on line #" + line;
            }
        }
    }
}
