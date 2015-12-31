using Iode.Methods;
using System;

namespace Iode.Library
{
    /// <summary>
    /// Outputs a message to the display without a newline
    /// </summary>
    public class Write : LibraryMethod
    {
        public override string name
        {
            get
            {
                return "write";
            }
        }

        public override Type returnType
        {
            get
            {
                return typeof(void);
            }
        }

        public override Type[] types
        {
            get
            {
                return new Type[] { typeof(string) };
            }
        }

        public static void generate(string msg)
        {
            Console.Write(msg);
        }
    }
}
