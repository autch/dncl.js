
digits      -?\d+(\.\d+)?
string      (["].*?["]|「.*?」)
var         [a-zA-Z][a-zA-Z0-9_]*
ident       (\w|[\u3040-\u309F\u30A0-\u30FF\u4E00-\u9FFF\uF900-\uFAFF！？])+

%%

\r?\n       return 'EOS';

{digits}    return 'DIGITS';
{var}       return 'VAR';

"["         return 'LSQBR';
"]"         return 'RSQBR';
","         return 'COMMA';

"←"        return 'LET';
":-"        return 'LET';

"("         return 'LBRACE';
")"         return 'RBRACE';

">="		return 'GE';
"≧"        return 'GE';
"<="		return 'LE';
"≦"        return 'LE';
"<>"		return 'NE';
"!="		return 'NE';
"≠"        return 'NE';
"="			return 'EQ';
"＝"		return 'EQ';
"<"			return 'LT';
"＜"		return 'LT';
">"			return 'GT';
"＞"		return 'GT';

"and"		return 'AND';
"or"		return 'OR';
"not"		return 'NOT';

"かつ"      return 'AND';
"または"    return 'OR';
"でない"    return 'POST_NOT';


"*"			return 'MUL';
"×"        return 'MUL';
"✕"        return 'MUL';
"/"			return 'DIV';
"／"		return 'DIV';
"÷"        return 'IDIV';   // integer division
"➗"        return 'IDIV';   // integer division
"+"			return 'ADD';
"＋"		return 'ADD';
"-"			return 'SUB';
"−"			return 'SUB';
"%"			return 'MOD';
"％"		return 'MOD';


"もし"      return 'IF';
"ならば"    return 'THEN';
"を実行する"  return 'ENDIF';
"を実行し"[、，]"そうでなくもし"      return 'ELIF';
"を実行し"[、，]"そうでなければ"      return 'ELSE';

"の間"[、，]   return 'DO_WHILE';
"を繰り返す"    return 'LOOP';

"から"      return 'FROM';
"まで"      return 'TO';
"ずつ"      return 'STEP';
"増やしながら"[、，]        return 'FOR_UPTO';
"減らしながら"[、，]        return 'FOR_DOWNTO';

"増やす"    return 'INCR';
"減らす"    return 'DECR';

"を表示する"  return 'PRINT';

"のすべての値を"    return 'ALL_VALUES_OF';
"にする"    return 'FILL';

"を"        return 'WO';
"と"        return 'CONCAT';

{ident}     return 'IDENT';
\s+         /* eat up spaces */
.           { console.error('INVALID: ' + yytext); return 'INVALID'; }
<<EOF>>     return 'EOF';
