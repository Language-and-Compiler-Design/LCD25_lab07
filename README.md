# Language and Compiler Design - NOVA FCT 2025

## Lab 7 – `CALCRef`, a language with heap allocated memory locations

This repository contains the starter code for **Lab 7** of the course **Language and Compiler Design**.  

In this lab, you will extend the previous lab sessions' work on the compiler of `CALCRef` language with heap allocated memory locations. This starting point does not yet have let implemented in all its aspects. Please modify your own ongoing project from Lab 3, 4 or 5 with the following new features. 

- `new(E)` to allocate a new memory location in the heap and initialize it with the value of expression `E`. The result of `new(E)` is a reference to the allocated memory location.

- `!E` to access the value stored in the memory location referenced by expression `E`.

- `E1 := E2` to update the memory location referenced by expression `E1` with the value of expression `E2`. The result of this expression is the value assigned to the memory location.

- `free(E)` to release the memory location referenced by expression `E`.

- `if E1 then E2 else E3` to evaluate the boolean expression `E1`, and if it evaluates to `true`, evaluate and return the result of expression `E2`; otherwise, evaluate and return the result of expression `E3`.

- `while E1 do E2` to repeatedly evaluate expression `E2` as long as the boolean expression `E1` evaluates to `true`.

- `E1; E2` to evaluate expression `E1`, discard its result, and then evaluate and return the result of expression `E2`.

- `printInt(E)` to print the integer value of expression `E` to the standard output.

- `printBool(E)` to print the boolean value of expression `E` to the standard output.

- `printEndLine()` to print a new line.

Note that now we no longer need to print the result in the end of the compiled file or at the end of the interpreter call.

Collect some files from this repository as reference. Your job is to implement declarations of identifiers in the style of let expressions. You need to implement the interpreter, the type systems, and the compiler to LLVM. Use the provided module `mem.ml` to manage memory locations in the interpreter, and the module `mem_runtime.c` to manage heap memory in the generated LLVM code.

### Action points

Assuming that you have completed the previous labs, the following steps outline the tasks you need to accomplish in this lab:

1. **Lexer**: Modify the lexer (`lexer.mll`) to recognize the new constructs for memory allocation, memory access, and memory release. You will need to add tokens for `new`, `!`, and `:=`. Add also the keywords and symbols required for the imperative constructs `;` (sequence), `if`, `then`, `else`, `while`, and `do`. Add operation `printInt` and `printBool` as well.

2. **Parser**: Update the parser (`parser.mly`) to handle the new expressions Ensure that the parser correctly constructs the AST for these expressions. The sequence, conditionals and `while` expressions have similar precedence as `let` expressions. Assignments have higher than let expressions but have a lower precedence when compared with the other existing operations. Sequences are left associative, Assignments and all the others are right associative.

3. **AST**: Extend the AST definition (`ast.ml`) to include the new constructors.

4. **Type System**: Implement the type checking for let expressions in the type system module (`typing.ml`). Follow the rules presented in the lecture slides. Add the type `Unit` and value `unit`.

5. **Interpreter**: Implement the evaluation of let expressions in the interpreter module (`eval.ml`). Use the functions in module `mem.ml` to allocate memory locations for the identifiers declared in the let expressions.

6. **LLVM Code Generation**: Extend the LLVM code generation module (`llvm.ml`) to handle imperative constructs expressions. This involves generating LLVM code that uses the functions in module `mem_runtime.c` and compiling the result together. 

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

This output should be placed in a file with the extension `ll` and compiled using `clang`. When using Unic, from the command line, you can redirect the output to a file using a `>` operator.

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

