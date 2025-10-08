# Language and Compiler Design - NOVA FCT 2025

## Lab 4 – `CALCB` type system and compiler with short-circuit evaluation

This repository contains the starter code for **Lab 4** of the course **Language and Compiler Design**.  
In this lab, you will extend the previous lab sessions' work on the `CALCB` language to implement short-circuit evaluation of boolean expressions and relational operators. To be able to generate code that compares both integer and boolean values, you need to implement a static type system that correctly identifies the types of the values being compared. You can then implement a compiler that translates `CALCB` expressions into LLVM code correctly.

### Action points

Assuming that you have completed the previous labs, the following steps outline the tasks you need to accomplish in this lab:

1. **Implement Relational Operators**: Extend the language to include relational operators such as `<`, `<=`, `>`, `>=`, `==`, and `!=`. These operators should work with both integer and boolean values, returning a boolean result. These operations can dynamically check the type of the operands to appropriately handle both integer and boolean values.

2. **Static Type System**: Implement a static type system that checks the types of expressions at compile time and labels the AST appropriately. Start with the given type checking function that was introduced in the lectures and is included in the `typing.ml` file. You will need to modify this function to annotate the AST with types.

3. **LLVM Code Generation**: Extend the compiler to generate LLVM code for the relational operators. Do not generate short-circuit evaluation in the LLVM code yet; instead, generate code that evaluates both sides of the expression and then performs the comparison using the appropriate LLVM instructions for the types involved.

4. **Implement Short-Circuit Interpreter**: Modify the interpreter to support short-circuit evaluation for boolean expressions. This means that in expressions like `A && B`, if `A` is false, `B` should not be evaluated, and similarly for `A || B`.

5. **LLVM Code Generation for Short-Circuit Evaluation**: Finally, extend the compiler to generate LLVM code that implements short-circuit evaluation for boolean expressions. This will involve generating labelled basic blocks, conditional branches in the LLVM code, and phi nodes to join the result in the end. 

### Hints

#### To implement the type system with an annotated AST

Analyse the file `typing.ml` to understand how to implement the type system. You will need to define a new type `ast` in the type system module (file `typing.ml`) to represent the output of the type system and later modify the input of the compiler to accept this typed AST.

```ocaml
type ann = { ty: calc_type }

type ast = 
    Num of ann * int
  | Bool of ann * bool
  
  | Add of ann * ast * ast
  ...
```

By defining the type `ann` for annotations, separately, you can easily modify the AST to include more meta information later. Now you need to adapt the type checking helper functions to return this new typed AST. For example, the helper function that checks operations on integers should look like this:

```ocaml
let type_int_int_int_bin_op mk e1 e2 = 
  match type_of e1, type_of e2 with
  | IntT, IntT -> mk IntT e1 e2
  | _ -> mk (None "Expecting Integer") e1 e2
```

By using the high order `mk` function to replace the general form of producing the expression back. You can create a new AST node with the correct type annotation. The `mk` function can be instantiated by functions like:

```ocaml
let mk_add t e1 e2 = Add (t,e1,e2) 
let mk_sub t e1 e2 = Sub (t,e1,e2) 
...
```

You will need to implement similar functions for all binary and unary operations.

```ocaml
let rec typecheck e =
  match e with  
  | Ast.Num n -> Num n
  | Ast.Bool b -> Bool b
  | Ast.Add (e1,e2) -> type_int_int_int_bin_op mk_add (typecheck e1) (typecheck e2)
  | Ast.Sub (e1,e2) -> type_int_int_int_bin_op mk_sub (typecheck e1) (typecheck e2)
  ...
```

#### To implement the short-circuit evaluation in the interpreter

The code that you need to produce to implement a short-circuit and expression like `A && B` is as follows:

```shell
A:
  %B = ...                             ; B is the register that holds the value of A
   br i1 %B, label %C, label %E

C:
  %D = ...                             ; D is the register that holds the value of B
  br label %G

E:
  %F = phi i1 [ false, %A ], [ %D, %C ]
  ...
```

The labels `A` to `H` represent fresh temporaries that need to be generated in this sequence.  The same pattern will be valid to implement the `A || B` expression. 

For conditional expressions with two branches, like `if A then B else C`, the code that you need to produce is as follows:


```ocaml
  %A = ...                             ; A is the register that holds the condition result
   br i1 %A, label %B, label %E

B:
  %C = ...                             ; C is the register that holds the result of the then branch
  br label %G

E:
  %F = ...                             ; F is the register that holds the result of the else branch
  br label %G

G:
  %H = phi i1 [ %C, %B ], [ %F, %E ]
  ...
```

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

