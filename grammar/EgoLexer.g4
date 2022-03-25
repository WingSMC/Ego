lexer grammar EgoLexer;

import UnicodeClasses;

/* Comment / Preproccessor */
PREPROCESSOR: '#' ~[\r\n]* -> skip;
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
LINE_COMMENT: '//' ~[\r\n]* -> skip;
WS: [ \t\f] -> skip;
NL: '\r'? '\n';

fragment BACKSLASH: '\\';
fragment ESCAPE_SEQ:
	BACKSLASH BACKSLASH
	| BACKSLASH '\''
	| BACKSLASH '"'
	| BACKSLASH '?'
	| BACKSLASH 'a'
	| BACKSLASH 'b'
	| BACKSLASH 'f'
	| BACKSLASH 'n'
	| BACKSLASH 'r'
	| (BACKSLASH ('\r' '\n'? | '\n'))
	| BACKSLASH 't'
	| BACKSLASH 'v';
fragment ARR: '[]';
fragment ARR_SIZED: '[' LIT_INT ']';

/************************* Operators *************************/
/* Memory / Declaration / Access */
// TODO ARRAY_ACCESS
SCOPE: '::';
ASSIGN: ':';
// FIXME same as bitwise &
ADDR: '&';
DEREF: '@';
ARROW_DEREF_ASSIGN: '->@:';
ARROW_DEREF: '->@';
ARROW_ASSIGN: '->:';
ARROW: '->';
DOT_DEREF_ASSIGN: '.@:';
DOT_DEREF: '.@';
DOT_ASSIGN: '.:';
DOT: '.';
S_COMMA: ',';
NEW_ARR: NEW ARR_SIZED;
DELETE_ARR: DELETE ARR;
UNIQUE_ARR: UNIQUE ARR_SIZED;
SHARED_ARR: SHARED ARR_SIZED;
NEW: 'new';
DELETE: 'delete';
UNIQUE: 'unique';
SHARED: 'shared';
NOT: 'not';
IS: 'is';
AS: 'as';
TYPEOF: 'typeof';
/* Comparison */
COMP_LTE: '<=';
COMP_LT: '<';
COMP_GTE: '>=';
COMP_GT: '>';
COMP_EQ: '==';
COMP_NEQ: '!=';
/* Arithmetic */
AR_INCR: '++';
AR_ADD_ASSIGN: '+:';
AR_ADD: '+';
AR_DECR: '--';
AR_SUB_ASSIGN: '-:';
AR_SUB: '-';
AR_EXP_ASSIGN: '**:';
AR_EXP: '**';
// TODO LOG?
AR_MUL_ASSIGN: '*:';
AR_MUL: '*';
AR_DIV_ASSIGN: '/:';
AR_DIV: '/';
AR_MOD_ASSIGN: '%:';
AR_MOD: '%';
SH_LS_ASSIGN: '<<<:';
SH_LS: '<<<';
SH_L_ASSIGN: '<<:';
SH_L: '<<';
SH_RS_ASSIGN: '>>>:';
SH_RS: '>>>';
SH_R_ASSIGN: '>>:';
SH_R: '>>';
ROT_LEFT_ASSIGN: '<=<:';
ROT_LEFT: '<=<';
ROT_RIGHT_ASSIGN: '>=>:';
ROT_RIGHT: '>=>';
BIT_AND_ASSIGN: '&:';
BIT_AND: '&';
BIT_OR_ASSIGN: '|:';
BIT_OR: '|';
BIT_XOR_ASSIGN: '^:';
BIT_XOR: '^';
BIT_NOT_NOT: '~~'; // ~~a is equivalent to a: ~a
BIT_NOT_ASSIGN: '~:';
BIT_NOT: '~';
/* Logical */
LOG_AND_ASSIGN: '&&:' | 'and:';
LOG_AND: '&&' | 'and';
LOG_OR_ASSIGN: '||:' | 'or:';
LOG_OR: '||' | 'or';
LOG_XOR_ASSIGN: '^^:' | 'xor:';
LOG_XOR: '^^' | 'xor';
LOG_NOT_NOT: '!!'; // !!a is equivalent to a: !a
LOG_NOT_ASSIGN: '!:' | 'not:';
LOG_NOT: '!' | 'not';
/* Other */
NULL_COALESCE_ASSIGN: '??:'; // Assign if lvalue is null
NULL_COALESCE: '??';
NULL_COALESCE_MEMBER_ASSIGN: '?.:';
NULL_COALESCE_MEMBER: '?.';
NULL_NON_NULL_ASSIGN: '?:'; // Assign if rvalue is not null
NULL_IS_NULL: '?';
ELLIPSIS: '...';

/* Module */
IMPORT: 'import';
EXPORT: 'export';

/* Typenames */
fragment T_VOID: 'void';
fragment T_BOOL: 'bool';
fragment T_INT_8: 'i8';
fragment T_INT_16: 'i16';
fragment T_INT_32: 'i32';
fragment T_INT_64: 'i64';
fragment T_INT_128: 'i128';
fragment T_UINT_8: 'u8';
fragment T_UINT_16: 'u16';
fragment T_UINT_32: 'u32';
fragment T_UINT_64: 'u64';
fragment T_UINT_128: 'u128';
fragment T_FLOAT: 'float';
fragment T_DOUBLE: 'double';
fragment T_CHAR: 'char';
fragment T_CHAR_16: 'char16';
fragment T_STRING: 'string';
fragment T_DECIMAL: 'decimal';
fragment T_COMPLEX: 'complex';
fragment T_REGEX: 'regex';
fragment T_AUTO: 'auto';
TYPENAME:
	T_BOOL
	| T_INT_8
	| T_INT_16
	| T_INT_32
	| T_INT_64
	| T_UINT_8
	| T_UINT_16
	| T_UINT_32
	| T_UINT_64
	| T_FLOAT
	| T_DOUBLE
	| T_DECIMAL
	| T_COMPLEX
	| T_CHAR
	| T_CHAR_16
	| T_STRING
	| T_AUTO
	| T_VOID;

/* Structures */
NAMESPACE: 'namespace';
ALIAS: 'alias';
ENUM: 'enum';
INTERFACE: 'interface';
CLASS: 'class';
RECORD: 'record';
OBJECT: 'object';
EXCEPTION: 'exception';
ANNOTATION: 'annotation';

/* Modifiers */
fragment M_PUBLIC: 'public';
fragment M_PROTECTED: 'protected';
fragment M_PRIVATE: 'private';
fragment M_INTERNAL: 'internal';
fragment M_VIRTUAL: 'virtual';
fragment M_OVERRIDE: 'override';
fragment M_INLINE: 'inline';
fragment M_ABSTRACT: 'abstract';
fragment M_STATIC: 'static';
fragment M_MUT: 'mut';
fragment M_VOLATILE: 'volatile';
M_ACCESS: M_PUBLIC | M_PROTECTED | M_PRIVATE | M_INTERNAL;
M_FUNCTION:
	M_INLINE
	| M_ABSTRACT
	| M_STATIC
	| M_VIRTUAL
	| M_OVERRIDE;
M_FIELD: M_STATIC | M_MUT | M_VOLATILE;
M_CLASS: M_VIRTUAL | M_ABSTRACT | M_STATIC;

/* Literals */
fragment DEC_DIGIT_NOZERO: UNICODE_CLASS_ND_NOZEROS;
fragment DEC_DIGIT: UNICODE_CLASS_ND;
fragment DEC_NUMBER: DEC_DIGIT_NOZERO DEC_DIGIT*;
fragment HEX_DIGIT: [0-9a-fA-F];
fragment HEX_QUAD: HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;
fragment HEX_NUMBER: '0' [xX] HEX_DIGIT+;
fragment BIN_DIGIT: [0-1];
fragment BIN_NUMBER: '0' [bB] BIN_DIGIT+;
fragment UNICODE_CHAR_LIT: BACKSLASH 'u' HEX_QUAD;
LIT_INT: DEC_NUMBER | HEX_NUMBER | BIN_NUMBER;
LIT_DOUBLE: ([1-9][0-9]* | '0')? '.' [0-9]+ ('e' [1-9][0-9]*)?;
LIT_NULL: 'null';
LIT_TRUE: 'true';
LIT_FALSE: 'false';
LIT_CHAR: '\'' (. | UNICODE_CHAR_LIT | ESCAPE_SEQ) '\'';
QUOTE_OPEN: '"' -> pushMode(LineString);
TRIPLE_QUOTE_OPEN: '"""' -> pushMode(MultiLineString);

/* Flow */
F_WHILE: 'while';
F_FOR: 'for';
F_DO: 'do';
F_IF: 'if';
F_ELIF: 'elif';
F_ELSE: 'else';
F_TRY: 'try';
F_CATCH: 'catch';
F_FINALLY: 'finally';
F_SWITCH: 'switch';
F_BREAK: '<|';
F_CONTINUE: '|>';
F_THROW: '=>>';
F_RETURN: '=';

/* Other keywords */
SUPER: 'super';
THIS: 'this';
THREAD: 'thread';

// TODO ternary and switch

LCURLY: '{';
RCURLY: '}';
LPAREN: '(' -> pushMode(Inside);
RPAREN: ')';
LSQUARE: '[' -> pushMode(Inside);
RSQUARE: ']';

fragment INTERPOLATED_VARIABLE: INTERPOLATION IDENTIFIER;
IDENTIFIER: [_a-zA-Z][_a-zA-Z0-9]*;
INTERPOLATION: '$';
// TODO
EOS: ';' | [\r\n][\r\n\t ]* ~'.';

mode Inside;
// TODO

mode LineString;
QUOTE_CLOSE: '"' -> popMode;
LineStrRef: INTERPOLATED_VARIABLE;
LineStrText: ~(BACKSLASH | '"' | '$')+ | '$';
LineStrEscapedChar: BACKSLASH . | UNICODE_CHAR_LIT;
LineStrExprStart: '${' -> pushMode(StringExpression);

mode MultiLineString;
TRIPLE_QUOTE_CLOSE: MultiLineStringQuote? '"""' -> popMode;
MultiLineStringQuote: '"'+;
MultiLineStrRef: INTERPOLATED_VARIABLE;
MultiLineStrText: ~(BACKSLASH | '"' | '$')+ | '$';
MultiLineStrEscapedChar: BACKSLASH .;
MultiLineStrExprStart:
	'$' LCURLY -> pushMode(StringExpression);
MultiLineNL: NL -> skip;

mode StringExpression;
StrExpr_RCURL: RCURLY -> popMode, type(RCURLY);
StrExpr_LPAREN: LPAREN -> pushMode(Inside), type(LPAREN);
StrExpr_LSQUARE: LSQUARE -> pushMode(Inside), type(LSQUARE);
// TODO

/* Unused symbols
 ??.:
 ??->:
 yield
 ===
 !==
 <-
 >-
 -> pointer member access
 -<
 <->
 >-<
 <--
 -->
 <<-
 >>-
 ->>
 -<<
 <-<
 >->
 <= LTE
 =>
 <=>
 <==
 ==>
 <==>
 <<=
 =>> throw
 >>=
 =<<
 >=> rotate_right
 <=< rotate_left
 >=<
 <~
 >~
 ~>
 ~<
 <~>
 <~~
 ~~>
 =<
 =!=
 -.-
 .-
 .=
 ..
 ~=
 <>
 ><
 `
 :<
 :>
 :(...)
 */
