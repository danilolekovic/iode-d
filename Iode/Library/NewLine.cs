using Iode.Methods;
using System;

namespace Iode.Library
{
    /// <summary>
    /// Outputs a newline to the display
    /// </summary>
    public class NewLine : LibraryMethod
    {
        public override string name
        {
            get
            {
                return "newln";
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
                return new Type[] { };
            }
        }

        public static void generate()
        {
            Console.WriteLine();
        }
    }
}
