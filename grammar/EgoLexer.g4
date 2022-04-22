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
LINE_COMMENT: '//' ~[\r\n]*  -> skip;
WHITESPACE: [ \t\f]          -> skip;
NL: '\r'? '\n';

LPAREN: '('  -> pushMode(Inside);
RPAREN: ')'  -> popMode;
LSQUARE: '[' -> pushMode(Inside);
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
FROM: 'from';
// AS is also a cast operator
STRUCT_ALIAS: 'alias';
STRUCT_ENUM: 'enum';
STRUCT_INTERFACE: 'interface';
STRUCT_CLASS: 'class';
STRUCT_RECORD: 'record';
STRUCT_OBJECT: 'object';
STRUCT_EXCEPTION: 'exception';
STRUCT_ANNOTATION: 'annotation';
STRUCT_ASM: 'asm' LCURLY .*? RCURLY;

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

/* Memory / Declaration / Access */
ELLIPSIS: '...';
RANGE: '..';
ARROW_DEREF: '->@';
ARROW: '->';
DOT_DEREF: '.@';
AT: '@';
DOT: '.';
COMMA: ',';
SEMI: ';';
NEW: 'new';
DELETE: 'delete';
UNIQUE: 'unique';
SHARED: 'shared';
IS: 'is';
AS: 'as';
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
THREAD: 'thread';
EVENT: 'event';
SUPER: 'super';
THIS: 'this';
VALUE: 'value';
DEFAULT: '_';
GET: 'get';
SET: 'set';

IDENTIFIER: [_a-zA-Z][_a-zA-Z0-9]*;

mode LineString;
QUOTE_CLOSE: '"'                              -> popMode;
LINE_STR_TEXT: ~["$\\\n\r]+                   -> type(STR_TEXT);
LINE_STR_ESCAPED_CHAR: STR_ESACAPED_CHAR_FRAG -> type(STR_ESCAPED_CHAR);
LINE_STR_REF: INTERP_VAR                      -> type(STR_REF);
LINE_STR_EXPR_START: STR_EXPRESSION_START     -> pushMode(StringExpression), type(STR_EXPR_START);
LINE_STR_NL: NL                               -> popMode, type(QUOTE_CLOSE);

mode MultiLineString;
TRIPLE_QUOTE_CLOSE: '"""'  -> popMode;
MULTILINE_STR_TEXT: ~["$]+ -> type(STR_TEXT);
MULTILINE_STR_QUOTE: '"' | '""';
MULTILINE_STR_REF: INTERP_VAR                  -> type(STR_REF);
MULTILINE_STR_EXPR_START: STR_EXPRESSION_START -> pushMode(StringExpression), type(STR_EXPR_START);

mode Inside;
INSIDE_RPAREN: RPAREN                                           -> popMode, type(RPAREN);
INSIDE_RSQUARE: RSQUARE                                         -> popMode, type(RSQUARE);
INSIDE_LPAREN: LPAREN                                           -> pushMode(Inside), type(LPAREN);
INSIDE_LSQUARE: LSQUARE                                         -> pushMode(Inside), type(LSQUARE);
INSIDE_LCURL: LCURLY                                            -> pushMode(DEFAULT_MODE), type(LCURLY);
INSIDE_TRIPLE_QUOTE_OPEN: TRIPLE_QUOTE_OPEN                     -> pushMode(MultiLineString), type(TRIPLE_QUOTE_OPEN);
INSIDE_QUOTE_OPEN: QUOTE_OPEN                                   -> pushMode(LineString), type(QUOTE_OPEN);
INSIDE_LIT_INT: LIT_INT                                         -> type(LIT_INT);
INSIDE_LIT_DOUBLE: LIT_DOUBLE                                   -> type(LIT_DOUBLE);
INSIDE_LIT_NULL: LIT_NULL                                       -> type(LIT_NULL);
INSIDE_LIT_TRUE: LIT_TRUE                                       -> type(LIT_TRUE);
INSIDE_LIT_FALSE: LIT_FALSE                                     -> type(LIT_FALSE);
INSIDE_LIT_CHAR: LIT_CHAR                                       -> type(LIT_CHAR);
INSIDE_F_IF: F_IF                                               -> type(F_IF);
INSIDE_F_ELIF: F_ELIF                                           -> type(F_ELIF);
INSIDE_F_ELSE: F_ELSE                                           -> type(F_ELSE);
INSIDE_F_WHEN: F_WHEN                                           -> type(F_WHEN);
INSIDE_F_EVAL: F_EVAL                                           -> type(F_EVAL);
INSIDE_SCOPE: SCOPE                                             -> type(SCOPE);
INSIDE_ADD_ASSIGN: ADD_ASSIGN                                   -> type(ADD_ASSIGN);
INSIDE_SUB_ASSIGN: SUB_ASSIGN                                   -> type(SUB_ASSIGN);
INSIDE_EXP_ASSIGN: EXP_ASSIGN                                   -> type(EXP_ASSIGN);
INSIDE_MUL_ASSIGN: MUL_ASSIGN                                   -> type(MUL_ASSIGN);
INSIDE_DIV_ASSIGN: DIV_ASSIGN                                   -> type(DIV_ASSIGN);
INSIDE_MOD_ASSIGN: MOD_ASSIGN                                   -> type(MOD_ASSIGN);
INSIDE_ROT_L_ASSIGN: ROT_L_ASSIGN                               -> type(ROT_L_ASSIGN);
INSIDE_ROT_R_ASSIGN: ROT_R_ASSIGN                               -> type(ROT_R_ASSIGN);
INSIDE_SH_L_S_ASSIGN: SH_L_S_ASSIGN                             -> type(SH_L_S_ASSIGN);
INSIDE_SH_R_S_ASSIGN: SH_R_S_ASSIGN                             -> type(SH_R_S_ASSIGN);
INSIDE_SH_L_ASSIGN: SH_L_ASSIGN                                 -> type(SH_L_ASSIGN);
INSIDE_SH_R_ASSIGN: SH_R_ASSIGN                                 -> type(SH_R_ASSIGN);
INSIDE_GT_ASSIGN: GT_ASSIGN                                     -> type(GT_ASSIGN);
INSIDE_LT_ASSIGN: LT_ASSIGN                                     -> type(LT_ASSIGN);
INSIDE_LOG_AND_ASSIGN: LOG_AND_ASSIGN                           -> type(LOG_AND_ASSIGN);
INSIDE_LOG_OR_ASSIGN: LOG_OR_ASSIGN                             -> type(LOG_OR_ASSIGN);
INSIDE_LOG_XOR_ASSIGN: LOG_XOR_ASSIGN                           -> type(LOG_XOR_ASSIGN);
INSIDE_BIT_AND_ASSIGN: BIT_AND_ASSIGN                           -> type(BIT_AND_ASSIGN);
INSIDE_BIT_OR_ASSIGN: BIT_OR_ASSIGN                             -> type(BIT_OR_ASSIGN);
INSIDE_BIT_XOR_ASSIGN: BIT_XOR_ASSIGN                           -> type(BIT_XOR_ASSIGN);
INSIDE_NULL_COALESCE_ASSIGN: NULL_COALESCE_ASSIGN               -> type(NULL_COALESCE_ASSIGN);
INSIDE_NULL_NON_NULL_ASSIGN: NULL_NON_NULL_ASSIGN               -> type(NULL_NON_NULL_ASSIGN);
INSIDE_NULL_COALESCE_MEMBER_ASSIGN: NULL_COALESCE_MEMBER_ASSIGN -> type(NULL_COALESCE_MEMBER_ASSIGN);
INSIDE_DOT_ASSIGN: DOT_ASSIGN                                   -> type(DOT_ASSIGN);
INSIDE_ARROW_DEREF_ASSIGN: ARROW_DEREF_ASSIGN                   -> type(ARROW_DEREF_ASSIGN);
INSIDE_ARROW_ASSIGN: ARROW_ASSIGN                               -> type(ARROW_ASSIGN);
INSIDE_DOT_DEREF_ASSIGN: DOT_DEREF_ASSIGN                       -> type(DOT_DEREF_ASSIGN);
INSIDE_ASSIGN: ASSIGN                                           -> type(ASSIGN);
INSIDE_AR_INCR: AR_INCR                                         -> type(AR_INCR);
INSIDE_AR_DECR: AR_DECR                                         -> type(AR_DECR);
INSIDE_BIT_NOT_NOT: BIT_NOT_NOT                                 -> type(BIT_NOT_NOT);
INSIDE_LOG_NOT_NOT: LOG_NOT_NOT                                 -> type(LOG_NOT_NOT);
INSIDE_ELLIPSIS: ELLIPSIS                                       -> type(ELLIPSIS);
INSIDE_RANGE: RANGE                                             -> type(RANGE);
INSIDE_ARROW_DEREF: ARROW_DEREF                                 -> type(ARROW_DEREF);
INSIDE_ARROW: ARROW                                             -> type(ARROW);
INSIDE_DOT_DEREF: DOT_DEREF                                     -> type(DOT_DEREF);
INSIDE_AT: AT                                                   -> type(AT);
INSIDE_DOT: DOT                                                 -> type(DOT);
INSIDE_COMMA: COMMA                                             -> type(COMMA);
INSIDE_IS: IS                                                   -> type(IS);
INSIDE_AS: AS                                                   -> type(AS);
INSIDE_TYPEOF: TYPEOF                                           -> type(TYPEOF);
INSIDE_AR_ADD: AR_ADD                                           -> type(AR_ADD);
INSIDE_AR_SUB: AR_SUB                                           -> type(AR_SUB);
INSIDE_AR_EXP: AR_EXP                                           -> type(AR_EXP);
INSIDE_AR_MUL: AR_MUL                                           -> type(AR_MUL);
INSIDE_AR_DIV: AR_DIV                                           -> type(AR_DIV);
INSIDE_AR_MOD: AR_MOD                                           -> type(AR_MOD);
INSIDE_SH_LS: SH_LS                                             -> type(SH_LS);
INSIDE_SH_L: SH_L                                               -> type(SH_L);
INSIDE_SH_RS: SH_RS                                             -> type(SH_RS);
INSIDE_SH_R: SH_R                                               -> type(SH_R);
INSIDE_ROT_LEFT: ROT_LEFT                                       -> type(ROT_LEFT);
INSIDE_ROT_RIGHT: ROT_RIGHT                                     -> type(ROT_RIGHT);
INSIDE_COMP_LTE: COMP_LTE                                       -> type(COMP_LTE);
INSIDE_COMP_LT: COMP_LT                                         -> type(COMP_LT);
INSIDE_COMP_GTE: COMP_GTE                                       -> type(COMP_GTE);
INSIDE_COMP_GT: COMP_GT                                         -> type(COMP_GT);
INSIDE_COMP_EQ: COMP_EQ                                         -> type(COMP_EQ);
INSIDE_COMP_NEQ: COMP_NEQ                                       -> type(COMP_NEQ);
INSIDE_LOG_AND: LOG_AND                                         -> type(LOG_AND);
INSIDE_LOG_OR: LOG_OR                                           -> type(LOG_OR);
INSIDE_LOG_XOR: LOG_XOR                                         -> type(LOG_XOR);
INSIDE_LOG_NOT: LOG_NOT                                         -> type(LOG_NOT);
INSIDE_AMP: AMP                                                 -> type(AMP);
INSIDE_BIT_OR: BIT_OR                                           -> type(BIT_OR);
INSIDE_BIT_XOR: BIT_XOR                                         -> type(BIT_XOR);
INSIDE_BIT_NOT: BIT_NOT                                         -> type(BIT_NOT);
INSIDE_NULL_COALESCE: NULL_COALESCE                             -> type(NULL_COALESCE);
INSIDE_NULL_COALESCE_MEMBER: NULL_COALESCE_MEMBER               -> type(NULL_COALESCE_MEMBER);
INSIDE_NULL_IS_NULL: NULL_IS_NULL                               -> type(NULL_IS_NULL);
INSIDE_SUPER: SUPER                                             -> type(SUPER);
INSIDE_THIS: THIS                                               -> type(THIS);
INSIDE_VALUE: VALUE                                             -> type(VALUE);
INSIDE_DEFAULT: DEFAULT                                         -> type(DEFAULT);
INSIDE_IDENTIFIER: IDENTIFIER                                   -> type(IDENTIFIER);

mode StringExpression;
STR_EXPR_RCURL: RCURLY                                            -> popMode, type(STR_EXPR_END);
STR_EXPR_LPAREN: LPAREN                                           -> pushMode(Inside), type(LPAREN);
STR_EXPR_LSQUARE: LSQUARE                                         -> pushMode(Inside), type(LSQUARE);
STR_EXPR_TRIPLE_QUOTE_OPEN: TRIPLE_QUOTE_OPEN                     -> pushMode(MultiLineString), type(TRIPLE_QUOTE_OPEN);
STR_EXPR_QUOTE_OPEN: QUOTE_OPEN                                   -> pushMode(LineString), type(QUOTE_OPEN);
STR_EXPR_LIT_INT: LIT_INT                                         -> type(LIT_INT);
STR_EXPR_LIT_DOUBLE: LIT_DOUBLE                                   -> type(LIT_DOUBLE);
STR_EXPR_LIT_NULL: LIT_NULL                                       -> type(LIT_NULL);
STR_EXPR_LIT_TRUE: LIT_TRUE                                       -> type(LIT_TRUE);
STR_EXPR_LIT_FALSE: LIT_FALSE                                     -> type(LIT_FALSE);
STR_EXPR_LIT_CHAR: LIT_CHAR                                       -> type(LIT_CHAR);
STR_EXPR_F_IF: F_IF                                               -> type(F_IF);
STR_EXPR_F_ELIF: F_ELIF                                           -> type(F_ELIF);
STR_EXPR_F_ELSE: F_ELSE                                           -> type(F_ELSE);
STR_EXPR_F_WHEN: F_WHEN                                           -> type(F_WHEN);
STR_EXPR_F_EVAL: F_EVAL                                           -> type(F_EVAL);
STR_EXPR_SCOPE: SCOPE                                             -> type(SCOPE);
STR_EXPR_ADD_ASSIGN: ADD_ASSIGN                                   -> type(ADD_ASSIGN);
STR_EXPR_SUB_ASSIGN: SUB_ASSIGN                                   -> type(SUB_ASSIGN);
STR_EXPR_EXP_ASSIGN: EXP_ASSIGN                                   -> type(EXP_ASSIGN);
STR_EXPR_MUL_ASSIGN: MUL_ASSIGN                                   -> type(MUL_ASSIGN);
STR_EXPR_DIV_ASSIGN: DIV_ASSIGN                                   -> type(DIV_ASSIGN);
STR_EXPR_MOD_ASSIGN: MOD_ASSIGN                                   -> type(MOD_ASSIGN);
STR_EXPR_ROT_L_ASSIGN: ROT_L_ASSIGN                               -> type(ROT_L_ASSIGN);
STR_EXPR_ROT_R_ASSIGN: ROT_R_ASSIGN                               -> type(ROT_R_ASSIGN);
STR_EXPR_SH_L_S_ASSIGN: SH_L_S_ASSIGN                             -> type(SH_L_S_ASSIGN);
STR_EXPR_SH_R_S_ASSIGN: SH_R_S_ASSIGN                             -> type(SH_R_S_ASSIGN);
STR_EXPR_SH_L_ASSIGN: SH_L_ASSIGN                                 -> type(SH_L_ASSIGN);
STR_EXPR_SH_R_ASSIGN: SH_R_ASSIGN                                 -> type(SH_R_ASSIGN);
STR_EXPR_GT_ASSIGN: GT_ASSIGN                                     -> type(GT_ASSIGN);
STR_EXPR_LT_ASSIGN: LT_ASSIGN                                     -> type(LT_ASSIGN);
STR_EXPR_LOG_AND_ASSIGN: LOG_AND_ASSIGN                           -> type(LOG_AND_ASSIGN);
STR_EXPR_LOG_OR_ASSIGN: LOG_OR_ASSIGN                             -> type(LOG_OR_ASSIGN);
STR_EXPR_LOG_XOR_ASSIGN: LOG_XOR_ASSIGN                           -> type(LOG_XOR_ASSIGN);
STR_EXPR_BIT_AND_ASSIGN: BIT_AND_ASSIGN                           -> type(BIT_AND_ASSIGN);
STR_EXPR_BIT_OR_ASSIGN: BIT_OR_ASSIGN                             -> type(BIT_OR_ASSIGN);
STR_EXPR_BIT_XOR_ASSIGN: BIT_XOR_ASSIGN                           -> type(BIT_XOR_ASSIGN);
STR_EXPR_NULL_COALESCE_ASSIGN: NULL_COALESCE_ASSIGN               -> type(NULL_COALESCE_ASSIGN);
STR_EXPR_NULL_NON_NULL_ASSIGN: NULL_NON_NULL_ASSIGN               -> type(NULL_NON_NULL_ASSIGN);
STR_EXPR_NULL_COALESCE_MEMBER_ASSIGN: NULL_COALESCE_MEMBER_ASSIGN -> type(NULL_COALESCE_MEMBER_ASSIGN);
STR_EXPR_DOT_ASSIGN: DOT_ASSIGN                                   -> type(DOT_ASSIGN);
STR_EXPR_ARROW_DEREF_ASSIGN: ARROW_DEREF_ASSIGN                   -> type(ARROW_DEREF_ASSIGN);
STR_EXPR_ARROW_ASSIGN: ARROW_ASSIGN                               -> type(ARROW_ASSIGN);
STR_EXPR_DOT_DEREF_ASSIGN: DOT_DEREF_ASSIGN                       -> type(DOT_DEREF_ASSIGN);
STR_EXPR_ASSIGN: ASSIGN                                           -> type(ASSIGN);
STR_EXPR_AR_INCR: AR_INCR                                         -> type(AR_INCR);
STR_EXPR_AR_DECR: AR_DECR                                         -> type(AR_DECR);
STR_EXPR_BIT_NOT_NOT: BIT_NOT_NOT                                 -> type(BIT_NOT_NOT);
STR_EXPR_LOG_NOT_NOT: LOG_NOT_NOT                                 -> type(LOG_NOT_NOT);
STR_EXPR_ELLIPSIS: ELLIPSIS                                       -> type(ELLIPSIS);
STR_EXPR_RANGE: RANGE                                             -> type(RANGE);
STR_EXPR_ARROW_DEREF: ARROW_DEREF                                 -> type(ARROW_DEREF);
STR_EXPR_ARROW: ARROW                                             -> type(ARROW);
STR_EXPR_DOT_DEREF: DOT_DEREF                                     -> type(DOT_DEREF);
STR_EXPR_AT: AT                                                   -> type(AT);
STR_EXPR_DOT: DOT                                                 -> type(DOT);
STR_EXPR_COMMA: COMMA                                             -> type(COMMA);
STR_EXPR_IS: IS                                                   -> type(IS);
STR_EXPR_AS: AS                                                   -> type(AS);
STR_EXPR_TYPEOF: TYPEOF                                           -> type(TYPEOF);
STR_EXPR_AR_ADD: AR_ADD                                           -> type(AR_ADD);
STR_EXPR_AR_SUB: AR_SUB                                           -> type(AR_SUB);
STR_EXPR_AR_EXP: AR_EXP                                           -> type(AR_EXP);
STR_EXPR_AR_MUL: AR_MUL                                           -> type(AR_MUL);
STR_EXPR_AR_DIV: AR_DIV                                           -> type(AR_DIV);
STR_EXPR_AR_MOD: AR_MOD                                           -> type(AR_MOD);
STR_EXPR_SH_LS: SH_LS                                             -> type(SH_LS);
STR_EXPR_SH_L: SH_L                                               -> type(SH_L);
STR_EXPR_SH_RS: SH_RS                                             -> type(SH_RS);
STR_EXPR_SH_R: SH_R                                               -> type(SH_R);
STR_EXPR_ROT_LEFT: ROT_LEFT                                       -> type(ROT_LEFT);
STR_EXPR_ROT_RIGHT: ROT_RIGHT                                     -> type(ROT_RIGHT);
STR_EXPR_COMP_LTE: COMP_LTE                                       -> type(COMP_LTE);
STR_EXPR_COMP_LT: COMP_LT                                         -> type(COMP_LT);
STR_EXPR_COMP_GTE: COMP_GTE                                       -> type(COMP_GTE);
STR_EXPR_COMP_GT: COMP_GT                                         -> type(COMP_GT);
STR_EXPR_COMP_EQ: COMP_EQ                                         -> type(COMP_EQ);
STR_EXPR_COMP_NEQ: COMP_NEQ                                       -> type(COMP_NEQ);
STR_EXPR_LOG_AND: LOG_AND                                         -> type(LOG_AND);
STR_EXPR_LOG_OR: LOG_OR                                           -> type(LOG_OR);
STR_EXPR_LOG_XOR: LOG_XOR                                         -> type(LOG_XOR);
STR_EXPR_LOG_NOT: LOG_NOT                                         -> type(LOG_NOT);
STR_EXPR_AMP: AMP                                                 -> type(AMP);
STR_EXPR_BIT_OR: BIT_OR                                           -> type(BIT_OR);
STR_EXPR_BIT_XOR: BIT_XOR                                         -> type(BIT_XOR);
STR_EXPR_BIT_NOT: BIT_NOT                                         -> type(BIT_NOT);
STR_EXPR_NULL_COALESCE: NULL_COALESCE                             -> type(NULL_COALESCE);
STR_EXPR_NULL_COALESCE_MEMBER: NULL_COALESCE_MEMBER               -> type(NULL_COALESCE_MEMBER);
STR_EXPR_NULL_IS_NULL: NULL_IS_NULL                               -> type(NULL_IS_NULL);
STR_EXPR_SUPER: SUPER                                             -> type(SUPER);
STR_EXPR_THIS: THIS                                               -> type(THIS);
STR_EXPR_VALUE: VALUE                                             -> type(VALUE);
STR_EXPR_DEFAULT: DEFAULT                                         -> type(DEFAULT);
STR_EXPR_IDENTIFIER: IDENTIFIER                                   -> type(IDENTIFIER);
