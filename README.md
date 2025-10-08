# Language and Compiler Design - NOVA FCT 2025

## Lab 4 – `CALCB` type system and compiler with short-circuit evaluation

This repository contains the starter code for **Lab 4** of the course **Language and Compiler Design**.  
In this lab, you will extend the previous lab sessions' work on the `CALCB` language to implement short-circuit evaluation of boolean expressions and relational operators. To be able to generate code that compares both integer and boolean values, you need to implement a static type system that correctly identifies the types of the values being compared. You can then implement a compiler that translates `CALCB` expressions into LLVM code correctly.

### Action points

Assuming that you have completed the previous labs, the following steps outline the tasks you need to accomplish in this lab:

1. **Implement Relational Operators**: Extend the language to include relational operators such as `<`, `<=`, `>`, `>=`, `==`, and `!=`. These operators should work with both integer and boolean values, returning a boolean result. These operations can dynamically check the type of the operands to appropriately handle both integer and boolean values.

2. **Static Type System**: Implement a static type system that checks the types of expressions at compile time and labels the AST appropriately. 

3. **LLVM Code Generation**: Extend the compiler to generate LLVM code for the relational operators. Do not generate short-circuit evaluation in the LLVM code yet; instead, generate code that evaluates both sides of the expression and then performs the comparison using the appropriate LLVM instructions for the types involved.

4. **Implement Short-Circuit Interpreter**: Modify the interpreter to support short-circuit evaluation for boolean expressions. This means that in expressions like `A && B`, if `A` is false, `B` should not be evaluated, and similarly for `A || B`.

5. **LLVM Code Generation for Short-Circuit Evaluation**: Finally, extend the compiler to generate LLVM code that implements short-circuit evaluation for boolean expressions. This will involve generating labelled basic blocks, conditional branches in the LLVM code, and phi nodes to join the result in the end. 

### Building the Project

Building the project follows the same steps as in previous labs. Make sure you have `dune` installed.

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

To research LLVM instructions, you can read the documentation online and can compile sample C programs to LLVM. The command to do so is

  ```bash
  clang -S -emit-llvm -c a.c -o a.ll
  ```

  the result will be a file called `a.ll`

