using Iode.CodeGen;
using Iode.Tests;
using System;
using System.Diagnostics;

namespace Iode
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.Title = "Iode";
            Stopwatch stopwatch = new Stopwatch();

            // Begin timing.
            stopwatch.Start();
            IodeGenerator.init("Test");
            stopwatch.Stop();

            // output benchmark
            Console.WriteLine("Time elapsed: {0}", stopwatch.Elapsed);
            Console.ReadLine();
        }
    }
}
