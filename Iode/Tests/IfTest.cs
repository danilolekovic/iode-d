using Iode.Analysis.Lexical;
using Iode.Analysis.Syntactic;
using Iode.AST;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;
using System.Reflection.Emit;

namespace Iode.Tests
{
    public class IfTest
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
            MethodBuilder methodBuilder = typeBuilder.DefineMethod("Main", MethodAttributes.Public | MethodAttributes.Static, typeof(void), new Type[] { typeof(string[]) });

            ILGenerator ilg = methodBuilder.GetILGenerator();

            Console.WriteLine("[" + DateTime.Now.ToString("hh.mm.ss.ffffff") + "] Initializing..");

            IfNode node = new IfNode(null, null); // null for now
            node.generate(ilg);

            Type t = typeBuilder.CreateType();
            assemblyBuilder.SetEntryPoint(methodBuilder, PEFileKinds.ConsoleApplication);
            Console.WriteLine("[" + DateTime.Now.ToString("hh.mm.ss.ffffff") + "] Saved exe..");
            assemblyBuilder.Save(programName + ".exe");
            Console.WriteLine("[" + DateTime.Now.ToString("hh.mm.ss.ffffff") + "] Running exe..");

            var p = new Process();

            p.StartInfo = new ProcessStartInfo(programName + ".exe")
            {
                UseShellExecute = false
            };

            p.Start();
            p.WaitForExit();
            Console.WriteLine("[" + DateTime.Now.ToString("hh.mm.ss.ffffff") + "] Finished.");
        }
    }
}
