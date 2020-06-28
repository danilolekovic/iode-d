<div align="center">
<p>
    <img src="http://i.imgur.com/icozONU.png">
</p>
<h1>The Iode Programming Language</h1>
</div>

### Information

Currently, the Iode programming language is being rewritten. This compiler is being written in [D](http://dlang.org). In the future, this compiler will be replaced by a compiler written in Iode itself -- self-hosting! The compiler itself is being phased from using LLVM (thankfully, this is happening very early on!) to using it's own bytecode (or maybe C) generator, as well as a JavaScript target.

The following is a tentative list, very much subject to change, of things that need to be done for this project:

- [x] Lexer
- [x] Parser
- [ ] Bytecode gen
- [X] JS gen
- [ ] Package manager
- [ ] Self-hosting
- [ ] Standard library
- [X] A website
- [ ] Documentation
- [ ] Speed!

The main goal right now is to create enough language functionality for this compiler to be able to be written in Iode. This will save time. So, what needs to be done is:

- [x] Functions
- [x] Variables
- [x] Classes
- [ ] Check if variable is already declared / compare types
- [ ] Imports
- [ ] If statements
- [ ] While/do/foreach/for loops
- [ ] Standard library
- [ ] Arrays
- [ ] Constructors
- [ ] x++ notation
- [ ] Conditional statements (||, &&)
- [ ] this
- [ ] Class instances
- [ ] Dictionaries
- [ ] Enumerations
- [ ] Constructors
- [ ] File I/O
- [ ] String manipulation
- [ ] Terminal manipulation
- [ ] Static class variables
- [ ] Modules
- [ ] Interfaces/abstract classes
- [ ] Type conversion


### License

The Iode programming language is licensed under an MIT license, available in the 'LICENSE' file.