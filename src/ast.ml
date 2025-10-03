(* This file contains the description of the calc language and some utils related to the AST *)

(* The abstract syntax tree (AST) type for the calc language *)
type ast = 
    Num of int
  | Add of ast * ast
  | Sub of ast * ast
  | Mul of ast * ast
  | Div of ast * ast
  | Neg of ast
  | Bool of bool
  | And of ast * ast
  | Or of ast * ast
  | Not of ast
  | Eq of ast * ast

let paren = fun p q s -> if p > q then "("^s^")" else s

(* This function converts an AST back to a string representation of the expression *)
let rec unparse_ast p e = 
  match e with
  | Num x -> string_of_int x
  | Add (e1,e2) -> paren p 10 (unparse_ast 10 e1 ^ " + " ^ unparse_ast 10 e2)
  | Sub (e1,e2) -> paren p 10 (unparse_ast 10 e1 ^ " - " ^ unparse_ast 11 e2)
  | Mul (e1,e2) -> paren p 30 (unparse_ast 20 e1 ^ " * " ^ unparse_ast 20 e2)
  | Div (e1,e2) -> paren p 20 (unparse_ast 20 e1 ^ " / " ^ unparse_ast 21 e2)
  | And (e1,e2) -> paren p 5 (unparse_ast 5 e1 ^ " && " ^ unparse_ast 5 e2)
  | Bool b -> string_of_bool b
  | Or (e1,e2) -> paren p 3 (unparse_ast 3 e1 ^ " || " ^ unparse_ast 3 e2)
  | Not e1 -> paren p 7 (" not " ^ unparse_ast 6 e1)
  | Eq (e1,e2) -> paren p 8 (unparse_ast 8 e1 ^ " = " ^ unparse_ast 8 e2)
  | _ -> assert false

