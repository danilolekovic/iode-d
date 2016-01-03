using Iode.Analysis.Syntactic;
using System;
using System.Runtime.Serialization;

namespace Iode.Exceptions
{
    /// <summary>
    /// Exception thrown during a parsing error
    /// </summary>
    public class ParsingException : Exception
    {
        public Parser parser { get; set; }
        public string msg { get; set; }

        public ParsingException(string message, Parser parser) : base(message)
        {
            this.parser = parser;
            this.msg = message + " on line #" + parser.line + ". Code: " + parser.lexer.code.Split('\n')[parser.line - 1];
        }

        public ParsingException(string message, Exception innerException, Parser parser) : base(message, innerException)
        {
            this.parser = parser;
            this.msg = message + " on line #" + parser.line + ". Code: " + parser.lexer.code.Split('\n')[parser.line - 1];
        }

        protected ParsingException(SerializationInfo info, StreamingContext context, Parser parser) : base(info, context)
        {
            this.parser = parser;
        }

        public override string Message
        {
            get
            {
                return msg;
            }
        }
    }
}
