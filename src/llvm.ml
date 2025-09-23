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
  | Addi32 (r,p1,p2) -> unparse_register r^" = add nsw i32 "^unparse_result p1^", "^unparse_result p2

let count = ref 0
let new_reg = fun () -> count := !count + 1; !count

let rec compile_llvm ret = function 
  | Num x -> Const x,[],[]
  | Add (e1,e2) -> 
    let r1,b1,bs1 = compile_llvm (new_reg()) e1 in
    let r2,b2,bs2 = compile_llvm (new_reg()) e2 in
    (Register ret, b1@b2@[Addi32 (ret,r1,r2)], bs1@bs2)
  | _ -> assert false (* Complete here this *)

let rec compile_llvm2 = function 
  | Num x -> Const x,[],[]
  | Add (e1,e2) -> 
    let r1,b1,bs1 = compile_llvm2 e1 in
    let r2,b2,bs2 = compile_llvm2 e2 in
    let ret = new_reg() in 
    (Register ret, b1@b2@[Addi32 (ret,r1,r2)], bs1@bs2)
  | _ -> assert false (* Complete here this *)

let emit_printf ret = 
    "  "^unparse_register (new_reg())^" = call i32 (ptr, ...) @printf(ptr noundef @.str, i32 noundef "^unparse_result ret^")"

let compile = compile_llvm2 
