lexer grammar EgoLexer;

import UnicodeClasses;

tokens {
}

channels {
}

fragment WS: [ \t\f\r\n]*;
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

WHITESPACE: [ \t\f] -> skip;
NL: '\r'? '\n';
PREPROCESSOR: '#' ~[\r\n]* -> skip;
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
LINE_COMMENT: '//' ~[\r\n]* -> skip;
SEMI: ';';

/************************* Operators *************************/
SCOPE: '::';
/* Assignments */
ADD_ASSIGN: '+:';
SUB_ASSIGN: '-:';
EXP_ASSIGN: '**:';
MUL_ASSIGN: '*:';
DIV_ASSIGN: '/:';
MOD_ASSIGN: '%:';
ROT_L_ASSIGN: '<=<:';
ROT_R_ASSIGN: '>=>:';
SH_L_S_ASSIGN: '<<<:';
SH_R_S_ASSIGN: '>>>:';
SH_L_ASSIGN: '<<:';
SH_R_ASSIGN: '>>:';
GT_ASSIGN: '<:';
LT_ASSIGN: '>:';
LOG_AND_ASSIGN: '&&:' | 'and:';
LOG_OR_ASSIGN: '||:' | 'or:';
LOG_XOR_ASSIGN: '^^:' | 'xor:';
BIT_AND_ASSIGN: '&:';
BIT_OR_ASSIGN: '|:';
BIT_XOR_ASSIGN: '^:';
NULL_COALESCE_ASSIGN: '??:'; // Assign if lvalue is null
NULL_NON_NULL_ASSIGN: '?:'; // Assign if rvalue is not null
NULL_COALESCE_MEMBER_ASSIGN: '?.:';
DOT_ASSIGN: '.:';
ARROW_DEREF_ASSIGN: '->@:';
ARROW_ASSIGN: '->:';
DOT_DEREF_ASSIGN: '.@:';
ASSIGN: ':';

AR_INCR: '++';
AR_DECR: '--';
BIT_NOT_NOT: '~~';
LOG_NOT_NOT: '!!';

/* Memory / Declaration / Access */
DEREF: '@';
ARROW_DEREF: '->@';
ARROW: '->';
DOT_DEREF: '.@';
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
AR_ADD: '+';
AR_SUB: '-';
AR_EXP: '**';
AR_MUL: '*';
AR_DIV: '/';
AR_MOD: '%';
SH_LS: '<<<';
SH_L: '<<';
SH_RS: '>>>';
SH_R: '>>';
ROT_LEFT: '<=<';
ROT_RIGHT: '>=>';
/* Logical */
LOG_AND: '&&' | 'and';
LOG_OR: '||' | 'or';
LOG_XOR: '^^' | 'xor';
LOG_NOT: '!' | 'not';
AMP: '&';
BIT_OR: '|';
BIT_XOR: '^';
BIT_NOT: '~';
/* Other */
NULL_COALESCE: '??';
NULL_COALESCE_MEMBER: '?.';
NULL_IS_NULL: '?';
ELLIPSIS: '...';

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
T_REAL: 'real';
T_COMPLEX: 'complex';
T_VEC_2: 'vec2';
T_VEC_3: 'vec3';
T_VEC_4: 'vec4';
T_MAT_2: 'mat2';
T_MAT_3: 'mat3';
T_MAT_4: 'mat4';
T_REGEX: 'regex';
T_AUTO: 'auto';

/* Module */
IMPORT: 'import';
EXPORT: 'export';
/* Structures */
STRUCT_NAMESPACE: 'namespace';
STRUCT_ALIAS: 'alias';
STRUCT_ENUM: 'enum';
STRUCT_INTERFACE: 'interface';
STRUCT_CLASS: 'class';
STRUCT_RECORD: 'record';
STRUCT_OBJECT: 'object';
STRUCT_EXCEPTION: 'exception';
STRUCT_ANNOTATION: 'annotation';
STRUCT_ASM: 'asm' LCURLY .? RCURLY;

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
M_REF: 'ref';

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
F_WHEN: 'when';
F_LABEL: 'label';
// opposite of break where break is implicitly added
F_BREAK: '<|' | 'break';
F_CONTINUE: '|>' | 'continue';
F_RETURN: '=' | 'ret' | 'return';
F_THROW: '=>>' | 'throw';
F_TRICKLE: '->' | 'trickle';
F_GOTO: '->>' | 'goto';

/* Other keywords */
SUPER: 'super';
THIS: 'this';
THREAD: 'thread';
GET: 'get';
SET: 'set';
DEFAULT: '_';

LCURLY: '{';
RCURLY: '}';
LPAREN: '(';
RPAREN: ')';
LSQUARE: '[';
RSQUARE: ']';

fragment INTERPOLATED_VARIABLE: INTERPOLATION IDENTIFIER;
IDENTIFIER: [_a-zA-Z][_a-zA-Z0-9]*;
INTERPOLATION: '$';

mode LineString;
QUOTE_CLOSE: '"' -> popMode;
LINE_STR_REF: INTERPOLATED_VARIABLE;
LINE_STR_TEXT: ~(BACKSLASH | '"' | '$')+ | '$';
LINE_STR_ESCAPED_CHAR: BACKSLASH . | UNICODE_CHAR_LIT;
LINE_STR_EXPR_START: '$' LCURLY -> pushMode(StringExpression);

mode MultiLineString;
TRIPLE_QUOTE_CLOSE: MULTILINE_STR_QUOTE? '"""' -> popMode;
MULTILINE_STR_QUOTE: '"'+;
MULTILINE_STR_REF: INTERPOLATED_VARIABLE;
MULTILINE_STR_TEXT:
	~(BACKSLASH | MULTILINE_STR_QUOTE | '$')+
	| '$';
MULTILINE_STR_ESC: BACKSLASH .;
MULTILINE_STR_EXPR_START:
	'$' LCURLY -> pushMode(StringExpression);
MULTILINE_NL: NL -> skip;

mode StringExpression;
STR_EXPR_RCURL: RCURLY -> popMode;
// TODO
