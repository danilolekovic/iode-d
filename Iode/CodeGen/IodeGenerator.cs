using Iode.Analysis.Lexical;
using Iode.Analysis.Syntactic;
using System;
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
            var methodBuilder = new DynamicMethod("Main", typeof(void), null);
            var ilGenerator = methodBuilder.GetILGenerator();

            Lexer lexer = new Lexer("puts(\"Hello\");");
            lexer.tokenize();

            Parser parser = new Parser(lexer);
            
            while (parser.pos != parser.totalTokens)
            {
                parser.parse().generate(ilGenerator);
            }

            ilGenerator.Emit(OpCodes.Ret);

            var @delegate = (Action)methodBuilder.CreateDelegate(typeof(Action));
            @delegate();
        }
    }
}
