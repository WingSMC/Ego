lexer grammar EgoLexer;

import UnicodeClasses;

/* Comment / Preproccessor */
PREPROCESSOR: '#' ~[\r\n]* -> skip;
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
LINE_COMMENT: '//' ~[\r\n]* -> skip;
WS: [ \t\f] -> skip;
NL: '\r'? '\n';

/* Module */
IMPORT: 'import';
EXPORT: 'export';

/* Typenames */
T_VOID: 'void';
T_BOOL: 'bool';
T_INT_8: 'i8';
T_INT_16: 'i16';
T_INT_32: 'i32';
T_INT_64: 'i64';
T_INT_128: 'i128';
T_UINT_8: 'u8';
T_UINT_16: 'u16';
T_UINT_32: 'u32';
T_UINT_64: 'u64';
T_UINT_128: 'u128';
T_FLOAT: 'float';
T_DOUBLE: 'double';
T_CHAR: 'char';
T_CHAR_16: 'char16';
T_STRING: 'string';
T_DECIMAL: 'decimal';
T_COMPLEX: 'complex';
T_REGEX: 'regex';
T_VAR: 'var';
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
	| T_VAR
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
M_PUBLIC: 'public';
M_PROTECTED: 'protected';
M_PRIVATE: 'private';
M_INTERNAL: 'internal';
M_VIRTUAL: 'virtual';
M_OVERRIDE: 'override';
M_INLINE: 'inline';
M_ABSTRACT: 'abstract';
M_STATIC: 'static';
M_MUT: 'mut';
M_VOLATILE: 'volatile';
M_CLASS_MODIFIER: M_VIRTUAL | M_ABSTRACT | M_STATIC;
M_CLASS_INHERITANCE: ':' IDENTIFIER (',' IDENTIFIER)*;

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
LIT_CHAR: '\'' (. | UNICODE_CHAR_LIT) '\'';
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
F_RETURN: '=>';

/* Other keywords */
SUPER: 'super';
THIS: 'this';

/* Operators */
fragment ARR: '[]';
fragment ARR_SIZED: '[' LIT_INT ']';

/* Memory / Declaration / Access */
// TODO ARRAY_ACCESS
SCOPE: '::';
ASSIGN: ':';
// FIXME same as bitwise &
ADDR: '&';
DEREF: '@';
ARROW_DEREF: '->@';
ARROW_DEREF_ASSIGN: '->@:';
ARROW_ASSIGN: '->:';
ARROW: '->';
DOT_DEREF: '.@';
DOT_DEREF_ASSIGN: '.@:';
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
BIT_NOT: '~';
BIT_NOT_NOT: '~~'; // ~~a is equivalent to a: ~a
/* Logical */
LOG_AND_ASSIGN: '&&:';
LOG_AND: '&&';
LOG_OR_ASSIGN: '||:';
LOG_OR: '||';
LOG_XOR_ASSIGN: '^^:';
LOG_XOR: '^^';
LOG_NOT: '!';
LOG_NOT_NOT: '!!'; // !!a is equivalent to a: !a
/* Other */
NON_NULL_EXPR_CHAIN: '??';
NON_NULL_MEMBER_CHAIN: '?.';
IS_NULL: '?';
ELLIPSIS: '...';
// TODO ternary and switch

LCURLY: '{';
RCURLY: '}';
LPAREN: '(' -> pushMode(Inside);
RPAREN: ')';
LSQUARE: '[' -> pushMode(Inside);
RSQUARE: ']';

/*
 S_TWO_DOTS: '..';
 S_SQUIGGLY_ARROW: '~>';
 S_LEFT_ARROW: '<-';
 S_TWO_WAY_ARROW:'<->';
 S_TWO_WAY_DOUBLE_ARROW: '<=>';
 S_DIAMOND: '<>';
 S_BACKTICK: '`';
 S_EQUAL: '=';
 */

fragment INTERPOLATED_VARIABLE: INTERPOLATION IDENTIFIER;
IDENTIFIER: [_a-zA-Z][_a-zA-Z0-9]*;
INTERPOLATION: '$';
// TODO
EOS: ';' | [\r\n][\r\n\t ]* ~'.';

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
