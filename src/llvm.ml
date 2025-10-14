open Typing

type register = int

type label = int

type result = 
  | Const of int
  | Register of register

type llvm = 
  | Addi32 of register * result * result 
  | CmpEq of Typing.calc_type * register * result * result
  | BrI1 of result * label * label
  | BrLabel of label
  | PhiI1 of register * (result * label) list

let count = ref 0
let new_reg = fun () -> count := !count + 1; !count
let new_label = new_reg

(* Code generation function *)

let rec compile_llvm e env label block = 
  match e with 
  | Num x -> Const x, label, block,[]
  | Bool b when b = true -> Const 1, label, block, []
  | Bool b when b = false -> Const 0, label, block, []
  | Add (_,e1,e2) -> 
    let r1,l1,b1,bs1 = compile_llvm e1 env label block in
    let r2,l2,b2,bs2 = compile_llvm e2 env l1 b1 in
    let ret = new_reg() in 
    (Register ret, l2, b2@[Addi32 (ret,r1,r2)], bs1@bs2)
  | And (_,e1,e2) -> 
    let r1,l1,b1,bs1 = compile_llvm e1 env label block in
    let label_b = new_label () in
    let r2,l2,b2,bs2 = compile_llvm e2 env label_b [] in
    let label_phi = new_label () in
    let bs = bs1@[(l1,b1@[BrI1 (r1, label_b, label_phi)])]@bs2@[(l2,b2@[BrLabel label_phi])] in
    let ret = new_reg () in
    (Register ret, label_phi, [PhiI1 (ret,[(r1, l1);(r2,l2)])], bs)
  | Eq (t,e1,e2) ->
    let r1,l1,b1,bs1 = compile_llvm e1 env label block in
    let r2,l2,b2,bs2 = compile_llvm e2 env l1 b1 in
    let ret = new_reg() in 
    (Register ret, l2, b2@[CmpEq (type_of e1,ret,r1,r2)], bs1@bs2) 
    (* This is OK, try (true && true) = (true && true) *)
  
  | Id (_,x) -> 
      begin match Env.lookup env x with 
      | None -> failwith ("Unbound identifier: "^x) 
      | Some r -> (r, label, block, []) 
      end

  | Let(_, [x,e], body) ->
    let r1,l1,b1,bs1 = compile_llvm e env label block in
    let env' = Env.begin_scope env in
    let env'' = Env.bind env' x r1 in
    let r2,l2,b2,bs2 = compile_llvm body env'' l1 b1 in
    let _ = Env.end_scope env'' in
    (r2, l2, b2, bs1@bs2)
  
  | Let(_,_,_) -> failwith "Multiple bindings in let not yet implemented"
  
  | _ -> failwith "Compiling not yet implemented"

(* Unparse LLVM functions *)

let prologue = 
  ["@.str = private unnamed_addr constant [4 x i8] c\"%d\\0A\\00\", align 1";
   "define i32 @main() #0 {"]

let epilogue = 
   ["  ret i32 0";
    "}";
    "declare i32 @printf(i8* noundef, ...) #1"]

let unparse_register n = "%"^string_of_int n

let unparse_label_use n = "%"^string_of_int n

let unparse_label_declaration l = (string_of_int l)^":"

let unparse_result = function 
  | Const x -> string_of_int x
  | Register x -> unparse_register x

let unparse_type = function
  | IntT -> "i32"
  | BoolT -> "i1"
  | _ -> failwith "Unknown type"

let unparse_llvm_i = function 
  | Addi32 (r,l1,l2) -> 
      "  "^unparse_register r^" = add nsw i32 "^unparse_result l1^", "^unparse_result l2
  | BrI1 (r, l1, l2) ->
      "  br i1 "^unparse_result r^", label "^unparse_label_use l1^", label "^unparse_label_use l2
  | BrLabel label ->
      "  br label "^unparse_label_use label
  | PhiI1 (r, l) ->
      "  "^unparse_register r^" = phi i1 "^String.concat ", " (List.map (fun (r,l) -> "["^unparse_result r^", "^unparse_label_use l^"]") l)
  | CmpEq (IntT, r, l1, l2) -> 
      "  "^unparse_register r^" = icmp eq i32 "^unparse_result l1^", "^unparse_result l2
  | CmpEq (BoolT, r, l1, l2) -> 
    "  "^unparse_register r^" = icmp eq i1 "^unparse_result l1^", "^unparse_result l2
  | CmpEq (t, _, _, _) -> failwith "Internal error: Cannot compare "^(unparse_type t)
      
let print_block (label, instructions) = 
    print_endline (unparse_label_declaration label);
    List.iter (fun x -> x |> unparse_llvm_i |> print_endline) instructions

let print_blocks bs = List.iter print_block bs 

let emit_printf ret t = 
  let llvm_type = unparse_type t
  in
    "  "^unparse_register (new_reg())^" = call i32 (i8*, ...) @printf(i8* noundef @.str, "^llvm_type^" noundef "^unparse_result ret^")"

let print_llvm (ret,label,instructions,blocks) t =
    (* Print the prologue *)
    List.iter print_endline prologue;
    (* Print the blocks *)
    print_blocks (blocks@[(label,instructions)]);
    (* Print the instruction printing the result *)
    print_endline (emit_printf ret t);
    (* Print the epilogue *)
    List.iter print_endline epilogue

let compile e = compile_llvm e Env.empty_env 0 []
