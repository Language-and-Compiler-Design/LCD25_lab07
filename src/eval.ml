(* This file contains the definitional interpreter for the calc language *)

open Ast

type result = 
  | IntV of int
  | BoolV of bool

let unparse_result r = 
  match r with 
  | IntV n -> string_of_int n
  | BoolV b -> string_of_bool b

let eval_int_int_int_binop f v1 v2 = 
  match v1, v2 with 
  | IntV n1, IntV n2 -> IntV (f n1 n2)
  | _ -> failwith "Dynamic typechecking error: expecting an integer got garbage."


let rec eval e =
  match e with  
  | Num n -> IntV n
  | Bool b -> BoolV b
  | Add (e1,e2) -> eval_int_int_int_binop ( + ) (eval e1) (eval e2)
  | Sub (e1,e2) -> eval_int_int_int_binop ( - ) (eval e1) (eval e2)
  | Mul (e1,e2) -> eval_int_int_int_binop ( * ) (eval e1) (eval e2)
  | Div (e1,e2) -> eval_int_int_int_binop ( / ) (eval e1) (eval e2)
  | Neg e1 -> eval_int_int_int_binop ( - ) (IntV 0) (eval e1) 
  | _ -> failwith "Not yet implemented"
