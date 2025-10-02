(* This is the main entry point for the calc language interpreter *)

open Calc_lib

let prologue = 
  ["@.str = private unnamed_addr constant [4 x i8] c\"%d\\0A\\00\", align 1";
   "define i32 @main() #0 {"]

let epilogue = 
   ["  ret i32 0";
    "}";
    "declare i32 @printf(i8* noundef, ...) #1"]

let parse_lexbuf lb =
  try Parser.main Lexer.read lb with
  | Parsing.Parse_error ->
      let pos = lb.Lexing.lex_curr_p in
      let col = pos.pos_cnum - pos.pos_bol in
      failwith (Printf.sprintf "Parse error at line %d, column %d" pos.pos_lnum col)

let parse_string s =
  Lexing.from_string s |> parse_lexbuf

let print_llvm (ret,instructions,_) =
    (* Print the prologue *)
    List.iter print_endline prologue;
    (* Print the instructions *)
    List.iter (fun x -> x |> Llvm.unparse_llvm_i |> print_endline) instructions;
    (* Print the instruction printing the result *)
    print_endline (Llvm.emit_printf ret);
    (* Print the epilogue *)
    List.iter print_endline epilogue

(* The main loop *)
let loop () =
  (* First the prompt *)
  print_string "> "; flush stdout;
  match read_line () with
  | s ->
      (try
          (* Parse the string and return an AST *)
          let e = parse_string s in 
          (* Print it out *)
          print_endline (Ast.unparse_ast 0 e);
          (* Call the compiler and receive the instructions *)
          let result = Llvm.compile e in
          (* Print the resulting LLVM program *)
          print_llvm result 
        with Failure msg ->
          Printf.eprintf "Error: %s\n%!" msg);
  | exception End_of_file -> print_endline "\nGoodbye!"

(* You cannot have top level computations, so we use, let () = ... *)
let () =
  (* First the message *)
  print_endline "Insert an expression. Ctrl+D to exit.";
  (* Then the loop *)
  loop ()


