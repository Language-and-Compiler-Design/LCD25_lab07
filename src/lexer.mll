{
  open Parser
  exception Lexing_error of string
}

rule read = parse
  | [' ' '\t' '\r' '\n']     { read lexbuf }       (* skip whitespace *)
  | ['0'-'9']+ as i          { INT (int_of_string i) }
  | "true"                  { TRUE }
  | "false"                 { FALSE }
  | "&&"                    { AND }
  | "||"                    { OR }
  | "not"                   { NOT }
  | "="                     { EQ }
  | "!="                    { NEQ }
  | "<"                     { LT }
  | ">"                     { GT }
  | "<="                    { LE }
  | ">="                    { GE }
  | '+'                      { PLUS }
  | '-'                      { MINUS }
  | '*'                      { TIMES }
  | '/'                      { DIV }
  | '('                      { LPAREN }
  | ')'                      { RPAREN }
  | "true"                   { TRUE }
  | "false"                  { FALSE }
  | "&&"                     { AND }
  | "||"                     { OR }
  | "let"                    { LET }
  | "in"                     { IN }
  | ['a'-'z' 'A'-'Z']+ as id  { ID id (* This must be in the end to avoid conflicts with keywords *) }
  | eof                      { EOF }
  | _ as c                   { raise (Lexing_error (Printf.sprintf "Unexpected char: %c" c)) }