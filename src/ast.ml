(* This file contains the description of the calc language and some utils related to the AST *)

(* The abstract syntax tree (AST) type for the calc language *)
type ast = 
    Num of int
  | Add of ast * ast
  | Sub of ast * ast
  | Mul of ast * ast
  | Div of ast * ast
  | Neg of ast

let paren = fun p q s -> if p > q then "("^s^")" else s

(* This function converts an AST back to a string representation of the expression *)
let rec unparse_ast p e = 
  match e with
  | Num x -> string_of_int x
  | Add (e1,e2) -> paren p 10 (unparse_ast 10 e1 ^ " + " ^ unparse_ast 10 e2)
  | Sub (e1,e2) -> paren p 10 (unparse_ast 10 e1 ^ " - " ^ unparse_ast 11 e2)
  | Mul (e1,e2) -> paren p 30 (unparse_ast 20 e1 ^ " * " ^ unparse_ast 20 e2)
  | Div (e1,e2) -> paren p 20 (unparse_ast 20 e1 ^ " / " ^ unparse_ast 21 e2)
  | Neg e1 -> paren p 30 ("-"^unparse_ast 31 e1)

