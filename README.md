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

The program asks for an expression to compile and outputs some LLVM code. For instance, if the expression is `1+2+3`, the output will be

```LLVM
@.str = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
define i32 @main() #0 {
%1 = add nsw i32 1, 2
%2 = add nsw i32 %1, 3
  %3 = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef %2)
  ret i32 0
}
declare i32 @printf(ptr noundef, ...) #1
```

This output should be placed in a file with the extension `ll` and compiled using `clang`

```bash
clang -o a a.ll
```

The result is the executable `a` which can be run from the console 

```bash
./a
```

to obtain the result `6`

### Extension points

- Inspect the code of the compiler to understand how the instructions are generated.

- Research LLVM instructions by reading the documentation and by compiling sample C programs to LLVM. The command to do so is

```bash
clang -S -emit-llvm -c a.c -o a.ll
```

the result will be a file called `a.ll`

- Extend the compiler to implement new instructions.