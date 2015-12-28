using Iode.Exceptions;
using Iode.Library;
using System;
using System.Collections.Generic;
using System.Reflection.Emit;

namespace Iode.AST
{
    /// <summary>
    /// Function call representation for the AST
    /// </summary>
    public class CallNode : Statement
    {
        public override NodeType type
        {
            get
            {
                return NodeType.CALL;
            }
        }

        /// <summary>
        /// Name of the function being called
        /// </summary>
        public string name { get; set; }

        /// <summary>
        /// Arguments in the call
        /// </summary>
        public List<Node> args { get; set; }

        public CallNode(string name, List<Node> args)
        {
            this.name = name;
            this.args = args;
        }

        public override void generate(ILGenerator ilg)
        {
            if (name.StartsWith("puts"))
            {
                if (args.Count > 1)
                {
                    throw new CodeGenException("\"" + name + "\" method accepts 1 argument.");
                }

                ilg.Emit(OpCodes.Ldstr, args[0].ToString());

                ilg.Emit(OpCodes.Call, typeof(Puts).GetMethod("puts", new Type[] { typeof(string) }));
            }
        }

        public override string ToString()
        {
            return name;
        }
    }
}
