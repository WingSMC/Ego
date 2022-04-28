lexer grammar EgoLexer;

import UnicodeClasses;

tokens {
  STR_REF,
  STR_EXPR_START,
  STR_EXPR_END,
  STR_ESCAPED_CHAR,
  STR_TEXT
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
fragment INTERP: '$';
fragment INTERP_VAR: INTERP IDENTIFIER;
fragment STR_ESACAPED_CHAR_FRAG: BACKSLASH . | UNICODE_CHAR_LIT;
fragment STR_EXPRESSION_START: INTERP LCURLY;
fragment DEC_DIGIT_NOZERO: UNICODE_CLASS_ND_NOZEROS;
fragment DEC_DIGIT: UNICODE_CLASS_ND;
fragment DEC_NUMBER: DEC_DIGIT_NOZERO DEC_DIGIT*;
fragment HEX_DIGIT: [0-9a-fA-F];
fragment HEX_QUAD: HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;
fragment HEX_NUMBER: '0' [xX] HEX_DIGIT+;
fragment BIN_DIGIT: [0-1];
fragment BIN_NUMBER: '0' [bB] BIN_DIGIT+;
fragment UNICODE_CHAR_LIT: BACKSLASH 'u' HEX_QUAD;

PREPROCESSOR: '#' ~[\r\n]*   -> skip;
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
M_REF: 'ref';
M_ASYNC: 'async';

/* Literals */
LIT_INT: DEC_NUMBER | HEX_NUMBER | BIN_NUMBER;
LIT_DOUBLE: ([1-9][0-9]* | '0')? '.' [0-9]+ ('e' [1-9][0-9]*)?;
LIT_NULL: 'null';
LIT_TRUE: 'true';
LIT_FALSE: 'false';
LIT_CHAR: '\'' (. | UNICODE_CHAR_LIT | ESCAPE_SEQ) '\'';
TRIPLE_QUOTE_OPEN: '"""' -> pushMode(MultiLineString);
QUOTE_OPEN: '"'          -> pushMode(LineString);

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
F_BREAK: '<|' | 'break';
F_CONTINUE: '|>' | 'continue';
F_RETURN: '=>' | 'ret' | 'return';
F_EVAL: '=' | 'eval';
F_THROW: '=>>' | 'throw';
F_TRICKLE: [~]+ '>' | 'trickle';
F_GOTO: '->>' | 'goto';
F_AWAIT: 'await';
F_YIELD: 'yield';

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
NULL_NON_NULL_ASSIGN: '?:';  // Assign if rvalue is not null
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

ELLIPSIS: '...';
RANGE: '..';
ARROW_DEREF: '->' '@'+;
ARROW: '->';
DOT_DEREF: '.' '@'+;
AT: '@';
DOT: '.';
COMMA: ',';
SEMI: ';';
NEW: 'new';
DELETE: 'delete';
UNIQUE: 'unique';
SHARED: 'shared';
IS: 'is';
TYPEOF: 'typeof';
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
/* Comparison */
COMP_LTE: '<=';
COMP_LT: '<';
COMP_GTE: '>=';
COMP_GT: '>';
COMP_EQ: '==';
COMP_NEQ: '!=';
/* Logical */
LOG_AND: '&&' | 'and';
LOG_NAND: '!&&' | 'nand';
LOG_OR: '||' | 'or';
LOG_NOR: '!||' | 'nor';
LOG_XOR: '^^' | 'xor';
LOG_XNOR: '!^^' | 'xnor';
LOG_NOT: '!' | 'not';
AMP: '&';
BIT_NAND: '~&';
BIT_OR: '|';
BIT_NOR: '~|';
BIT_XOR: '^';
BIT_XNOR: '~^';
BIT_NOT: '~';
/* Other */
NULL_COALESCE: '??';
NULL_COALESCE_MEMBER: '?.';
NULL_IS_NULL: '?';

/* Other keywords */
ASM: 'asm' -> pushMode(Asm);
THREAD: 'thread';
EVENT: 'event';
SUPER: 'super';
THIS: 'this';
VALUE: 'value';
FIELD: 'field';
GET: 'get';
SET: 'set';
DEFAULT: '_' | 'default';
IDENTIFIER: [a-zA-Z][_a-zA-Z0-9]* | '_' [_a-zA-Z0-9]+;

mode LineString;
QUOTE_CLOSE: '"'                              -> popMode;
LINE_STR_TEXT: ~["$\\\n\r]+                   -> type(STR_TEXT);
LINE_STR_ESCAPED_CHAR: STR_ESACAPED_CHAR_FRAG -> type(STR_ESCAPED_CHAR);
LINE_STR_REF: INTERP_VAR                      -> type(STR_REF);
LINE_STR_EXPR_START: STR_EXPRESSION_START     -> pushMode(DEFAULT_MODE), type(STR_EXPR_START);
LINE_STR_NL: NL                               -> popMode, type(NL);

mode MultiLineString;
TRIPLE_QUOTE_CLOSE: MULTILINE_STR_QUOTE? '"""'     -> popMode;
MULTILINE_STR_TEXT: ~["$]+                         -> type(STR_TEXT);
MULTILINE_STR_ESCAPED_CHAR: STR_ESACAPED_CHAR_FRAG -> type(STR_ESCAPED_CHAR);
MULTILINE_STR_REF: INTERP_VAR                      -> type(STR_REF);
MULTILINE_STR_EXPR_START: STR_EXPRESSION_START     -> pushMode(DEFAULT_MODE), type(STR_EXPR_START);
MULTILINE_STR_QUOTE: '"' | '""';

mode Asm;
ASM_LCURLY: ' '* ('\r'? '\n')* ' '* '{' -> type(LCURLY);
ASM_RCURLY: '}'                         -> type(RCURLY), popMode;
ASM_CONTENT: ~[{}]+;
