using Iode.Analysis.Types;
using Iode.CodeGen;
using Iode.Exceptions;
using Iode.Methods;
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
            if (Stash.libMethodExists(name))
            {
                LibraryMethod lm = Stash.getLibMethod(name);

                if (args.Count != 0)
                {
                    if (lm.types.Length != args.Count)
                    {
                        throw new CodeGenException("Method \"" + name + "\" does not expect " + args.Count + " params, it expects " + lm.types.Length + " params.");
                    }

                    for (int i = 0; i < args.Count; i++)
                    {
                        if (!TypeChecker.sameType(args[i], lm.types[i]))
                        {
                            throw new CodeGenException("Method \"" + name + "\": param #" + (i + 1) + " is expected to have the type of \"" + lm.types[i].ToString() + "\"");
                        }
                        else
                        {
                            args[i].generate(ilg);
                        }
                    }
                }

                if (lm.types.Length == 0)
                {
                    ilg.Emit(OpCodes.Call, lm.GetType().GetMethod("generate"));
                }
                else
                {
                    ilg.Emit(OpCodes.Call, lm.GetType().GetMethod("generate", lm.types));
                }
            }
            else if (Stash.methodExists(name))
            {
                // todo
            }
        }

        public override string ToString()
        {
            return name;
        }
    }
}
