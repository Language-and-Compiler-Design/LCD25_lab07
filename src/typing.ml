(* This file contains the definitional interpreter for the calc language *)

open Ast

type calc_type = 
  | IntT 
  | BoolT
  | None

let unparse_type = function
  | IntT -> "int"
  | BoolT -> "boolean"
  | None -> "typing error"

let type_int_int_int_bin_op t1 t2 = 
  match t1, t2 with
  | IntT, IntT -> IntT
  | _ -> None

let type_bool_bool_bool_bin_op t1 t2 = 
  match t1, t2 with
  | IntT, IntT -> IntT
  | _ -> None

let type_int_int_bool_bin_op t1 t2 = 
  match t1, t2 with
  | IntT, IntT -> BoolT
  | _ -> None

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
  | Eq (e1,e2) -> type_int_int_bool_bin_op  (typecheck e1) (typecheck e2)
  | _ -> assert false


