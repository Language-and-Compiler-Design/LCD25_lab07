%{
open Ast
%}

%token <int> INT
%token PLUS MINUS TIMES DIV LPAREN RPAREN OR AND EQ TRUE FALSE EOF 

%start main
%type <Ast.ast> main

%%
main:
  expr EOF                { $1 }

expr: 
  | expr OR conj        { Or ($1, $3) }
  | conj                { $1 }

conj:
  | conj AND rel        { And ($1, $3) }
  | rel                 { $1 }

rel: 
  | rel EQ arith        { Eq ($1, $3) }
  | arith               { $1 }

arith:
  | arith PLUS  term      { Add ($1, $3) }
  | arith MINUS term      { Sub ($1, $3) }
  | term                  {$1}

term:
  | term TIMES  factor      { Mul ($1, $3) }
  | term DIV    factor      { Div ($1, $3) }
  | factor                 {$1}

factor: 
  | TRUE                  { Bool true }
  | FALSE                 { Bool false }
  | INT                   { Num $1 }
  | LPAREN expr RPAREN    { $2 }
  | MINUS factor          { Neg $2 }
;