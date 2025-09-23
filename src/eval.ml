(* This file contains the definitional interpreter for the calc language *)

open Ast

let rec eval e =
  match e with  
  | Num n -> n
  | Add (e1,e2) -> eval e1 + eval e2
  | Sub (e1,e2) -> eval e1 - eval e2
  | Mul (e1,e2) -> eval e1 * eval e2
  | Div (e1,e2) -> eval e1 / eval e2
  | Neg e1 -> - eval e1 
