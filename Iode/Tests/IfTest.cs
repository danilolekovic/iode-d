using Iode.AST;
using System;
using System.Collections.Generic;
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
            var methodBuilder = new DynamicMethod("Main", typeof(void), null);
            var ilGenerator = methodBuilder.GetILGenerator();

            new IfNode(new BooleanNode(true), new List<Node>() { new CallNode("puts", new List<Node>() { new StringNode("Hello") }) }).generate(ilGenerator);

            ilGenerator.Emit(OpCodes.Ret);

            var @delegate = (Action)methodBuilder.CreateDelegate(typeof(Action));
            @delegate();
        }
    }
}
