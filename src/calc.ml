(* This is the main entry point for the calc language interpreter *)

open Calc_lib

let parse_lexbuf lb =
  try Parser.main Lexer.read lb with
  | Parsing.Parse_error ->
      let pos = lb.Lexing.lex_curr_p in
      let col = pos.pos_cnum - pos.pos_bol in
      failwith (Printf.sprintf "Parse error at line %d, column %d" pos.pos_lnum col)

let parse_string s =
  Lexing.from_string s |> parse_lexbuf

let () =
  print_endline "Insert an expression. Ctrl+D to exit.";
  let rec loop () =
    print_string "> "; flush stdout;
    match read_line () with
    | s ->
        (try
           let e = parse_string s in 
           print_endline (Ast.unparse_ast 0 e);
           let v = Eval.eval e in
           Printf.printf "= %d\n%!" v
         with Failure msg ->
           Printf.eprintf "Error: %s\n%!" msg);
        loop ()
    | exception End_of_file -> print_endline "\nGoodbye!"
  in
  loop ()
 
