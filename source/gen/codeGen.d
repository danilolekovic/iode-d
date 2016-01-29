module iode.gen.codeGen;

import std.stdio;
import llvm.c;
import iode.lexical.token;
import iode.lexical.lexer;
import iode.parsing.parser;
import iode.ast.node;
import iode.gen.stash;

class CodeGenerator {
    public static void run(string code) {
        Lexer lexer = new Lexer(code);
    	lexer.tokenize();

    	Parser parser = new Parser(lexer);
    	Node[] ast;

    	while (parser.pos != parser.totalTokens) {
    		ast ~= parser.start();
    	}

    	Stash.theModule = LLVMModuleCreateWithName("Iode");
    	Stash.builder = LLVMCreateBuilder();

    	char[1024] error;
    	char* errorPtr = error.ptr;

    	LLVMExecutionEngineRef engine;

    	int result = LLVMCreateExecutionEngineForModule(&engine, Stash.theModule, &errorPtr);

    	if (result == 1) {
    		writeln(to!string(errorPtr));
    		writeln("Cannot create execution engine ! Exiting...");
    		return;
    	}

    	Stash.engine = engine;

    	// Setup optimisation passes
    	Stash.passManager = LLVMCreateFunctionPassManagerForModule(Stash.theModule);
    	LLVMAddTargetData(LLVMGetExecutionEngineTargetData(Stash.engine), Stash.passManager);
    	LLVMAddPromoteMemoryToRegisterPass(Stash.passManager);
    	LLVMAddBasicAliasAnalysisPass(Stash.passManager);
    	LLVMAddReassociatePass(Stash.passManager);
    	LLVMAddInstructionCombiningPass(Stash.passManager);
    	LLVMAddGVNPass(Stash.passManager);
    	LLVMAddCFGSimplificationPass(Stash.passManager);

    	foreach (n; ast) {
    		n.generate();
    	}

    	LLVMDumpModule(Stash.theModule);
    }
}
