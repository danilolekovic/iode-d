using Iode.AST;
using System.Collections.Generic;
using System.Reflection.Emit;

namespace Iode.Methods
{
    /// <summary>
    /// Base class for built-in Iode methods
    /// </summary>
    public abstract class LibraryMethod : Method
    {
        public abstract void generate(List<Expression> args, ILGenerator ilg);
    }
}
