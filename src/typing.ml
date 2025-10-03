(* This file contains the definitional interpreter for the calc language *)

open Ast

type calc_type = 
  | IntT 
  | BoolT
  | None of string

let unparse_type = function
  | IntT -> "int"
  | BoolT -> "boolean"
  | None m -> "typing error: "^m

let type_int_int_int_bin_op t1 t2 = 
  match t1, t2 with
  | IntT, IntT -> IntT
  | _ -> None "Expecting Integer"

let type_bool_bool_bool_bin_op t1 t2 = 
  match t1, t2 with
  | BoolT, BoolT -> IntT
  | _ -> None "Expecting Boolean"

let type_int_int_bool_bin_op t1 t2 = 
  match t1, t2 with
  | IntT, IntT -> BoolT
  | _ -> None "Expecting Integer"

let type_a_a_eqop t1 t2 = if t1 = t2 then t1 else None "Expecting equal types"

let rec typecheck e =
  match e with  
  | Num _ -> IntT
  | Bool _ -> BoolT
  | Add (e1,e2) -> type_int_int_int_bin_op  (typecheck e1) (typecheck e2)
  | Sub (e1,e2) -> type_int_int_int_bin_op  (typecheck e1) (typecheck e2)
  | Mul (e1,e2) -> type_int_int_int_bin_op  (typecheck e1) (typecheck e2)
  | Div (e1,e2) -> type_int_int_int_bin_op  (typecheck e1) (typecheck e2)
  | Neg e1 ->  type_int_int_int_bin_op (IntT) (typecheck e1)
  | And (e1,e2) -> type_bool_bool_bool_bin_op  (typecheck e1) (typecheck e2)
  | Or (e1,e2) -> type_bool_bool_bool_bin_op  (typecheck e1) (typecheck e2)
  | Eq (e1,e2) -> type_a_a_eqop (typecheck e1) (typecheck e2)
  | _ -> failwith "Not yet implemented..."


