using Iode.AST;
using Iode.Methods;
using System;
using System.Collections.Generic;
using System.Reflection.Emit;

namespace Iode.Library
{
    /// <summary>
    /// Outputs a message to the display
    /// </summary>
    public class Puts : LibraryMethod
    {
        public override string name
        {
            get
            {
                return "puts";
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

        public override void generate(List<Expression> args, ILGenerator ilg)
        {
            foreach (Expression n in args)
            {
                string val = Convert.ToString(n.value);
                ilg.Emit(OpCodes.Ldstr, val);
                ilg.Emit(OpCodes.Call, typeof(Console).GetMethod("Write", new Type[] { typeof(string) }));
            }

            ilg.Emit(OpCodes.Ldstr, "\n");
            ilg.Emit(OpCodes.Call, typeof(Console).GetMethod("Write", new Type[] { typeof(string) }));
        }
    }
}
