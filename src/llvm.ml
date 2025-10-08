open Ast

type register = int

type result = 
  | Const of int
  | Register of register

type llvm = 
  | Addi32 of register * result * result 

let unparse_register n = "%"^string_of_int n

let unparse_result = function 
  | Const x -> string_of_int x
  | Register x -> unparse_register x

let unparse_llvm_i = function 
  | Addi32 (r,p1,p2) -> 
      "  "^unparse_register r^" = add nsw i32 "^unparse_result p1^", "^unparse_result p2

let count = ref 0
let new_reg = fun () -> count := !count + 1; !count

let rec compile_llvm e = 
  match e with 
  | Num x -> Const x,[],[]
  | Add (e1,e2) -> 
    let r1,b1,bs1 = compile_llvm e1 in
    let r2,b2,bs2 = compile_llvm e2 in
    let ret = new_reg() in 
    (Register ret, b1@b2@[Addi32 (ret,r1,r2)], bs1@bs2)
  | _ -> failwith "Not yet implemented"

let emit_printf ret = 
    "  "^unparse_register (new_reg())^" = call i32 (i8*, ...) @printf(i8* noundef @.str, i32 noundef "^unparse_result ret^")"

let compile = compile_llvm
