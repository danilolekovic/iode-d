module iode.gen.codeGen;

import std.stdio;
import std.string;
import std.conv;
import iode.lexical.token;
import iode.lexical.lexer;
import iode.parsing.parser;
import iode.ast.node;
import iode.gen.stash;
import llvm;

class CodeGenerator {
	public static LLVMModuleRef mod;
    public static LLVMBuilderRef builder;
    public static LLVMPassManagerRef passManager;
    public static LLVMExecutionEngineRef engine;
	public static NodeFunction[string] funcs;

    public static void run(string code, bool js) {
        Lexer lexer = new Lexer(code);
    	lexer.tokenize();

    	Parser parser = new Parser(lexer);
    	Node[] ast;

        // todo: replace this
    	while (parser.pos != parser.totalTokens) {
    		ast ~= parser.start();
    	}

		if (js) {
			string builder = "";

			foreach (Node n; ast) {
				builder ~= n.generateJS() ~ "\n";
			}

			writeln(builder);
		} else {
			mod = LLVMModuleCreateWithName("Iode".toStringz());
			builder = LLVMCreateBuilder();

			char[1024] error;
			char* errorPtr = error.ptr;

			LLVMExecutionEngineRef eng;

			char* jitError = null;

			int result = LLVMCreateExecutionEngineForModule(&engine, mod, &errorPtr);

			if (result == 1) {
				writeln(to!string(errorPtr));
				writeln("Error creating execution engine..");
				return;
			}

			engine = eng;
			passManager = LLVMCreateFunctionPassManagerForModule(mod);
			LLVMAddPromoteMemoryToRegisterPass(passManager);
			LLVMAddBasicAliasAnalysisPass(passManager);
			LLVMAddReassociatePass(passManager);
			LLVMAddInstructionCombiningPass(passManager);
			LLVMAddGVNPass(passManager);
			LLVMAddCFGSimplificationPass(passManager);

			foreach (n; ast) {
				n.generate();
			}

			auto execResult = LLVMRunFunctionAsMain(engine, funcs["main"].generate(), 0, null, null);
			writefln("-> %d", LLVMGenericValueToInt(LLVMCreateGenericValueOfInt(LLVMInt32Type(), execResult, 0), 0));

			LLVMDisposePassManager(passManager);
			LLVMDisposeBuilder(builder);
			LLVMDisposeExecutionEngine(engine);
		}
    }
}
