module iode.vm.vm;

import iode.vm.codes;
import std.stdio;
import std.conv;

class VM {
    public static void vm(int[] program) {
        int programCounter = 0;
        int[100] stack;
        int stackPointer = 0;

        while (programCounter < program.length) {
            auto currentInstruction = program[programCounter];

            switch (currentInstruction) {
                case ByteCode.PUSH:
                    stack[stackPointer] = program[programCounter + 1];
                    stackPointer++;
                    programCounter++;
                    break;
                case ByteCode.ADD:
                    int right = stack[stackPointer - 1];
                    stackPointer--;
                    int left = stack[stackPointer - 1];
                    stackPointer--;

                    stack[stackPointer] = left + right;
                    stackPointer++;
                    break;
                case ByteCode.SUB:
                    int right = stack[stackPointer - 1];
                    stackPointer--;
                    int left = stack[stackPointer - 1];
                    stackPointer--;

                    stack[stackPointer] = left - right;
                    stackPointer++;
                    break;
                default: break; // throw an error here
            }

            programCounter++;
        }

        writeln("stacktop: " ~ to!string(stack[stackPointer - 1]));
    }
}