using Iode.Analysis.Lexical;
using Iode.Analysis.Syntactic;
using Iode.AST;
using Iode.Exceptions;
using System;
using System.Collections.Generic;
using System.Reflection;
using System.Reflection.Emit;

namespace Iode.CodeGen
{
    public class IodeGenerator
    {
        public static AppDomain appDomain;
        public static AssemblyBuilder assemblyBuilder;
        public static ModuleBuilder moduleBuilder;

        public static void init(string programName)
        {
            AssemblyName an = new AssemblyName();
            an.Name = programName;
            appDomain = AppDomain.CurrentDomain;
            assemblyBuilder = appDomain.DefineDynamicAssembly(an, AssemblyBuilderAccess.Save);
            moduleBuilder = assemblyBuilder.DefineDynamicModule(an.Name, programName + ".exe");

            TypeBuilder typeBuilder = moduleBuilder.DefineType("Iode." + programName, TypeAttributes.Public | TypeAttributes.Class);

            Lexer lexer = new Lexer("def main() { (msg, name) = \"Hello\", \"John\"; puts(name); }");
            lexer.tokenize();

            Parser parser = new Parser(lexer);
            List<Node> ast = new List<Node>();
            
            while (parser.pos != parser.totalTokens)
            {
                ast.Add(parser.parse());
            }

            if (Stash.methodExists("main"))
            {
                var methodBuilder = Stash.generateMethod("main", typeBuilder.Module);
                var ilGenerator = methodBuilder.GetILGenerator();
                List<Node> mainMethod = Stash.getMethod("main").body;
                Stash.loadedMethods.Add("main");

                foreach (Node n in ast)
                {
                    if (n.type == NodeType.DECLARATION)
                    {
                        n.generate(ilGenerator); // generate all variables
                    }
                }

                foreach (Node n in mainMethod)
                {
                    n.generate(ilGenerator);
                }

                ilGenerator.Emit(OpCodes.Ret);

                var @delegate = (Action)methodBuilder.CreateDelegate(typeof(Action));
                @delegate();
            }
            else
            {
                throw new CodeGenException("0");
            }
        }
    }
}
