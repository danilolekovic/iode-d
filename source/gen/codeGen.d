module iode.gen.codeGen;

import std.stdio;
import std.string;
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

        // todo: replace this
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
    		writeln("Error creating execution engine..");
    		return;
    	}

    	Stash.engine = engine;
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

        auto execResult = LLVMRunFunctionAsMain(Stash.engine, Stash.funcs["main"].generate(), 0, null, null);
        writefln("-> %d", LLVMGenericValueToInt(LLVMCreateGenericValueOfInt(LLVMInt32Type(), execResult, 0), 0));

        LLVMDisposePassManager(Stash.passManager);
        LLVMDisposeBuilder(Stash.builder);
        LLVMDisposeExecutionEngine(Stash.engine);
    }
}
