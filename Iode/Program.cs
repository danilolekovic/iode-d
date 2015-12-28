using Iode.CodeGen;
using System;

namespace Iode
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Title = "Iode";
            IodeGenerator.init("Test");
            Console.ReadLine();
        }
    }
}
