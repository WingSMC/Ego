lexer grammar EgoLexer;

channels {
  PREPROCESSOR,
  DOCUMENTATION
}

tokens {
  STR_DOLLAR,
  STR_REF,
  STR_EXPR_START,
  STR_ESCAPED_CHAR,
  STR_TEXT
}

fragment WS: [ \t\f\r\n]*;
fragment BACKSLASH: '\\';
fragment ESCAPE_SEQ:
  BACKSLASH BACKSLASH
  | BACKSLASH '0'
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
fragment INTERP: '$';
fragment INTERP_VAR: INTERP IDENTIFIER;
fragment STR_ESACAPED_CHAR_FRAG: BACKSLASH . | UNICODE_CHAR_LIT;
fragment STR_EXPRESSION_START: INTERP LCURLY;
fragment DEC_DIGIT_NOZERO: [1-9];
fragment DEC_DIGIT: [0-9];
fragment DEC_NUMBER: DEC_DIGIT_NOZERO DEC_DIGIT*;
fragment HEX_DIGIT: [0-9a-fA-F];
fragment HEX_QUAD: HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;
fragment HEX_NUMBER: '0' [xX] HEX_DIGIT+;
fragment BIN_DIGIT: [0-1];
fragment BIN_NUMBER: '0' [bB] BIN_DIGIT+;
fragment UNICODE_CHAR_LIT: BACKSLASH 'u' HEX_QUAD;

PREPROC: '<%' .*? '%>'       -> channel(PREPROCESSOR);
DOC_COMMENT: '/**' .*? '*/'  -> channel(DOCUMENTATION);
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
LONE_BLOCK_COMMENT_END: '*/' -> skip;
LINE_COMMENT: '//' ~[\r\n]*  -> skip;
WHITESPACE: [ \t\f]          -> skip;
NL: '\r'? '\n';

LPAREN: '('  -> pushMode(DEFAULT_MODE);
RPAREN: ')'  -> popMode;
LSQUARE: '[' -> pushMode(DEFAULT_MODE);
RSQUARE: ']' -> popMode;
LCURLY: '{'  -> pushMode(DEFAULT_MODE);
RCURLY: '}'  -> popMode;

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
T_VAR: 'var';

/* Module */
MODULE: 'module';
IMPORT: 'import';
EXPORT: 'export';
AS: 'as';
STRUCT_ALIAS: 'alias';
STRUCT_ENUM: 'enum';
STRUCT_INTERFACE: 'interface';
STRUCT_CLASS: 'class';
STRUCT_RECORD: 'record';
STRUCT_OBJECT: 'object';
STRUCT_EXCEPTION: 'exception';
STRUCT_ANNOTATION: 'annotation';

/* Modifiers */
M_PUBLIC: 'public';
M_PROTECTED: 'protected';
M_PRIVATE: 'private';
M_INTERNAL: 'internal';
M_VIRTUAL: 'virtual';
M_OVERRIDE: 'override';
M_ABSTRACT: 'abstract';
M_STATIC: 'static';
M_CONST: 'const';
M_VOLATILE: 'volatile';
M_TRANSIENT: 'transient';
M_ASYNC: 'async';

/* Literals */
LIT_INT: (DEC_NUMBER | HEX_NUMBER | BIN_NUMBER | '0');
LIT_DOUBLE: ([1-9][0-9]* | '0')? '.' [0-9]+ ('e' [1-9][0-9]*)?;
LIT_NULL: 'null';
LIT_TRUE: 'true';
LIT_FALSE: 'false';
LIT_CHAR: '\'' (UNICODE_CHAR_LIT | ESCAPE_SEQ | .) '\'';
BACKTICK_OPEN: IDENTIFIER? (AT | HASH | INTERP)* '`' -> pushMode(MultiLineString);
QUOTE_OPEN: '"'                                      -> pushMode(LineString);

/* Flow */
F_WHILE: 'while';
F_FOR: 'for';
F_DO: 'do';
F_IF: 'if';
F_ELSE: 'else';
F_SWITCH: 'switch';
F_TRY: 'try';
F_CATCH: 'catch';
F_FINALLY: 'finally';
F_BREAK: '<|' | 'break';
F_CONTINUE: '|>' | 'continue';
F_RETURN: '=>' | 'ret' | 'return';
F_EVAL: '=' | 'eval';
F_THROW: '=>>' | 'throw';
F_TRICKLE: '~>' | 'trickle';
F_GOTO: '->>' | 'goto';
F_AWAIT: 'await';
F_YIELD: 'yield';

/************************* Operators *************************/
SCOPE: '::';
/* Assignments */
ADD_ASSIGN: ADD ASSIGN;
SUB_ASSIGN: SUB ASSIGN;
EXP_ASSIGN: EXP ASSIGN;
MUL_ASSIGN: MUL ASSIGN;
DIV_ASSIGN: DIV ASSIGN;
MOD_ASSIGN: MOD ASSIGN;
ROT_L_ASSIGN: ROT_L ASSIGN;
ROT_R_ASSIGN: ROT_R ASSIGN;
SH_L_S_ASSIGN: SH_LS ASSIGN;
SH_R_S_ASSIGN: SH_RS ASSIGN;
SH_L_ASSIGN: SH_L ASSIGN;
SH_R_ASSIGN: SH_R ASSIGN;
GT_ASSIGN: GT ASSIGN;
LT_ASSIGN: LT ASSIGN;
NEQ_ASSIGN: NEQ ASSIGN;
LOG_AND_ASSIGN: LOG_AND ASSIGN;
LOG_OR_ASSIGN: LOG_OR ASSIGN;
LOG_XOR_ASSIGN: LOG_XOR ASSIGN;
BIT_AND_ASSIGN: BIT_AND ASSIGN;
BIT_OR_ASSIGN: BIT_OR ASSIGN;
BIT_XOR_ASSIGN: BIT_XOR ASSIGN;
COALESCE_ASSIGN: COALESCE ASSIGN; // Assign if lvalue is null
NON_NULL_ASSIGN: IS_NULL ASSIGN;  // Assign if rvalue is not null
COALESCE_MEMBER_ASSIGN: COALESCE_MEMBER ASSIGN;
DOT_ASSIGN: DOT ASSIGN;
ARROW_DEREF_ASSIGN: ARROW_DEREF ASSIGN;
ARROW_ASSIGN: ARROW ASSIGN;
DOT_DEREF_ASSIGN: DOT_DEREF ASSIGN;
ASSIGN: ':';

AR_INCR: ADD ADD;
AR_DECR: SUB SUB;
BIT_NOT_NOT: BIT_NOT BIT_NOT;
LOG_NOT_NOT: LOG_NOT LOG_NOT;

ELLIPSIS: DOT DOT DOT;
RANGE: DOT DOT;
ARROW_DEREF: ARROW AT+;
ARROW: '->';
DOT_DEREF: DOT AT+;
AT: '@'; // Makeref, deref
DOT: '.';
COMMA: ',';
SEMI: ';';
NEW: 'new';
DELETE: 'delete';
UNIQUE: 'unique';
SHARED: 'shared';
/* Arithmetic */
ADD: '+';
SUB: '-';
EXP: MUL MUL;
LOG: MOD MOD;
MUL: '*';
DIV: '/';
MOD: '%';
SH_LS: '<<<';
SH_L: '<<';
SH_RS: '>>>';
SH_R: '>>';
ROT_L: '<=<';
ROT_R: '>=>';
/* Comparison */
LTE: '<=';
LT: '<';
GTE: '>=';
GT: '>';
EQ: '==';
NEQ: '!=';
/* Logical */
LOG_AND: BIT_AND BIT_AND | 'and';
LOG_NAND: LOG_NOT LOG_AND | 'nand';
LOG_OR: BIT_OR BIT_OR | 'or';
LOG_NOR: LOG_NOT LOG_OR | 'nor';
LOG_XOR: BIT_XOR BIT_XOR | 'xor';
LOG_XNOR: LOG_NOT LOG_XOR | 'xnor';
LOG_NOT: '!' | 'not';
BIT_AND: '&'; // Also addressOf
BIT_NAND: BIT_NOT BIT_AND;
BIT_OR: '|';
BIT_NOR: BIT_NOT BIT_OR;
BIT_XOR: '^';
BIT_XNOR: BIT_NOT BIT_XOR;
BIT_NOT: '~';
/* Other */
IS: 'is';
IS_NOT: LOG_NOT IS | IS LOG_NOT;
COALESCE: IS_NULL IS_NULL;
COALESCE_MEMBER: IS_NULL DOT;
IS_NULL: '?';

/* Other keywords */
ASM_START: 'asm' WS '{' -> pushMode(Asm);
IN: 'in';
OF: 'of';
STEP: 'step';
SIZEOF: 'sizeof';
TYPEOF: 'typeof';
GLOBAL: 'global';
THREAD: 'thread';
EVENT: 'event';
SUPER: 'super';
THIS: 'this';
VALUE: 'value';
FIELD: 'field';
GET: 'get';
SET: 'set';
HASH: '#';
DEFAULT: '_' | 'default';
IDENTIFIER: [a-zA-Z][_a-zA-Z0-9]* | '_' [_a-zA-Z0-9]+;

mode LineString;
QUOTE_CLOSE: '"'                              -> popMode;
LINE_STR_TEXT: ~["$\\\n\r]+                   -> type(STR_TEXT);
LINE_STR_ESCAPED_CHAR: STR_ESACAPED_CHAR_FRAG -> type(STR_ESCAPED_CHAR);
LINE_STR_DOLLAR: INTERP INTERP                -> type(STR_DOLLAR);
LINE_STR_REF: INTERP_VAR                      -> type(STR_REF);
LINE_STR_EXPR_START: STR_EXPRESSION_START     -> pushMode(DEFAULT_MODE), type(STR_EXPR_START);
LINE_STR_NL: NL                               -> popMode, type(NL);

mode MultiLineString;
BACKTICK_CLOSE: '`'                            -> popMode;
MULTILINE_STR_TEXT: ~[$`]+                     -> type(STR_TEXT);
MULTILINE_STR_DOLLAR: INTERP INTERP            -> type(STR_DOLLAR);
MULTILINE_STR_REF: INTERP_VAR                  -> type(STR_REF);
MULTILINE_STR_EXPR_START: STR_EXPRESSION_START -> pushMode(DEFAULT_MODE), type(STR_EXPR_START);

mode Asm;
ASM_LCURLY: '{' -> pushMode(Asm), type(ASM_START);
ASM_RCURLY: '}' -> type(RCURLY), popMode;
ASM_CONTENT: ~[{}]+;
