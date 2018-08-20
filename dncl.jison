%left COMMA
%left OR
%left AND
%nonassoc EQ NE
%nonassoc LT GT LE GE
%left ADD SUB
%left MUL DIV IDIV MOD
%nonassoc NOT POST_NOT
%nonassoc NEG
%nonassoc FUNCALL

%start program

%%

program: statements EOF { $$ = $1; return $$; }
;

statements:            { $$ = []; }
| statements statement { $1.push($2); $$ = $1; }
;

statement: EOS         { $$ = null; }
| stmt EOS             { $$ = $1; }
;

stmt: let
| print
| funcall
| if
| while
| for
| incr
| fill
;

let: let_atom           { $$ = [$1]; }
| let COMMA let_atom    { $1.push($3); $$ = $1; }
;
let_atom: var_ref LET expr  { $$ = ['LET', $1, $3]; }
;

print: print_values PRINT   { $$ = ['PRINT', $1] }
;

print_values: expr_or_string             { $$ = [$1]; }
| print_values CONCAT expr_or_string     { $1.push($3); $$ = $1; }
;
expr_or_string: STRING
| expr
;

value: DIGITS                           { $$ = Number(yytext); }
| LBRACE expr RBRACE                    { $$ = $2; }
| var_ref
;

var_ref: VAR                            { $$ = ['VAR_REF', $1]; }
| VAR LSQBR arglist RSQBR               { $$ = ['VAR_REF', $1, $3]; }
;

funcall: IDENT LBRACE arglist RBRACE    { $$ = ['FUNCALL', $1, $3]; }
;
arglist:                        { $$ = []; }
| arglist_m                     
;
arglist_m: expr                 { $$ = [$1]; }
| arglist COMMA expr            { $1.push($3); $$ = $1; }
;

if: single_if
| multi_if
;
single_if: IF condition THEN stmt                                       { $$ = ['IF', $2, [$4]]; }
;
multi_if: IF condition THEN EOS statements elseif_list else ENDIF       { $$ = ['IF', $2, $5, $6, $7 ]; }
;
elseif_list: elseif     { $$ = [$1]; }
| elseif_list elseif    { $1.push($2); $$ = $1; }
;
elseif:                             { $$ = null; }
| ELIF condition EOS statements     { $$ = ['ELIF', $2, $4 ]; }
;
else:                               { $$ = null; }
| ELSE EOS statements               { $$ = ['ELSE', $3 ]; }
;

while: condition DO_WHILE EOS statements LOOP   { $$ = ['WHILE', $1, $4]; }
;

for: VAR WO expr FROM expr TO expr STEP upto_or_downto EOS statements LOOP { $$ = ['FOR', $1, $3, $5, $7, $9, $11]; }
;
upto_or_downto: FOR_UPTO    { $$ = 1; }
| FOR_DOWNTO                { $$ = -1; }
;

fill: VAR ALL_VALUES_OF expr FILL   { $$ = ['FILL', 'ALL', $1, $3]; }
;

incr: VAR WO expr INCR      { $$ = ['INCR', $1, $3]; }
| VAR WO expr DECR          { $$ = ['DECR', $1, $3]; }
;

condition: comparison
| logical
| LBRACE condition RBRACE   { $$ = $2; }
;

comparison: expr EQ expr    { $$ = ['=', $1, $3]; }
| expr NE expr              { $$ = ['!=', $1, $3]; }
| expr GE expr              { $$ = ['>=', $1, $3]; }
| expr LE expr              { $$ = ['<=', $1, $3]; }
| expr GT expr              { $$ = ['>', $1, $3]; }
| expr LT expr              { $$ = ['<', $1, $3]; }
;

logical: NOT condition      { $$ = ['!', $2]; }
| condition POST_NOT        { $$ = ['!', $1]; }
| condition AND condition   { $$ = ['&', $1, $3]; }
| condition OR condition    { $$ = ['|', $1, $3]; }
;

expr: funcall
| unary
| binary
| value
;

unary: SUB expr %prec NEG   { $$ = ['NEG', $2]; }
;

binary: expr ADD expr       { $$ = ['+', $1, $3]; }
| expr SUB expr             { $$ = ['-', $1, $3]; }
| expr MUL expr             { $$ = ['*', $1, $3]; }
| expr DIV expr             { $$ = ['/', $1, $3]; }
| expr IDIV expr            { $$ = ['DIV', $1, $3]; }
| expr MOD expr             { $$ = ['%', $1, $3]; }
;
