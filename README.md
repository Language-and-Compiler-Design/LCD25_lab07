# Language and Compiler Design - NOVA FCT 2025

## Lab 2 – Expression Language Compiler for LLVM

This repository contains the starter code for **Lab 2** of the course **Language and Compiler Design**.  
In this lab, you will work with a compiler for a simple expression language named CALC.

---

### Building the Project

Run the following command inside the project root:

```bash
dune build
```

This compiles the interpreter and related modules.

### Running the Compiler

After building, you can run the interpreter with:

```bash
dune exec calcc
```

This will start the program that evaluates expressions written in the defined expression language.

### Structure

src/ – main executable and core modules 

### Next Steps

Familiarise yourself with the code structure.

Try evaluating some example expressions.

Implement the extension points in the code

Be ready to extend the interpreter in future labs (e.g. adding compilation to LLVM).