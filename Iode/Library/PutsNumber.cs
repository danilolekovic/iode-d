using Iode.Methods;
using System;

namespace Iode.Library
{
    /// <summary>
    /// Outputs a number to the display
    /// </summary>
    public class PutsNumber : LibraryMethod
    {
        public override string name
        {
            get
            {
                return "puts_i";
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
                return new Type[] { typeof(double) };
            }
        }

        public static void generate(double msg)
        {
            Console.WriteLine(msg);
        }
    }
}
