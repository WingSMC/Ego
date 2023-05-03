lexer grammar EgoV2Lexer;

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

fragment INTERP_VAR: '$' ID;
fragment STR_EXPRESSION_START: '${';
fragment DEC_DIGIT_NOZERO: [1-9];
fragment DEC_DIGIT: [0-9];
fragment DEC_NUMBER: DEC_DIGIT_NOZERO DEC_DIGIT*;
fragment HEX_DIGIT: [0-9a-fA-F];
fragment HEX_QUAD: HEX_DIGIT HEX_DIGIT HEX_DIGIT HEX_DIGIT;
fragment HEX_NUMBER: '0' [xX] HEX_DIGIT+;
fragment BIN_DIGIT: '0' | '1';
fragment BIN_NUMBER: '0' [bB] BIN_DIGIT+;
fragment STR_ESCAPED_CHAR_FRAG: '\\' . | UNICODE_CHAR_LIT;
fragment UNICODE_CHAR_LIT: '\\u' HEX_QUAD;

DOC_COMMENT: '/**' .*? '*/'  -> channel(DOCUMENTATION);
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
LINE_COMMENT: '//' ~[\r\n]*  -> skip;
WS: [ \t\r\n]+               -> skip;
STATIC_ACCESS_OP: '::';
RANGE: '..';
ACCESS_OP: '.' | '->';
COLON: ':';

LCURLY: '{'  -> pushMode(DEFAULT_MODE);
RCURLY: '}'  -> popMode;
LPAREN: '(';
RPAREN: ')';
LSQUARE: '[';
RSQUARE: ']';
COMMA: ',';
SEMI: ';';

MODULE: 'module';
IMPORT: 'import';
EXPORT: 'export';
AS: 'as';
CLASS: 'class';
USE: 'use';
INTERFACE: 'interface';
IMPL: 'impl';
THIS: 'this';
VAR: 'var';
LOOP: 'loop';
WHILE: 'while';
FOR: 'for';
IN: 'in';
DO: 'do';
IF: 'if';
ELSE: 'else';
WHEN: 'when';
BREAK: 'break';
CONTINUE: 'continue';
YIELD: 'yield';
RET: 'ret' | '=>';
TRICKLE: 'trickle' | '~>';
JMP: 'jmp';
MUT: 'mut';
PUB: 'pub';
PRO: 'pro';
STATIC: 'static';
VIRTUAL: 'virtual';
OVERRIDE: 'override';
ABSTRACT: 'abstract';

/* Operators */
IS: 'is';
NEW: 'new';
UNIQUE: 'unique';
SHARED: 'shared';
DELETE: 'delete';
PIPE: '|>';
AT: '@';
TAG: '#';

INCREMENT: '++';
DECREMENT: '--';
LOGIC_FLIP: '!!';
BIN_FLIP: '~~';
ENDIAN_BIT_SWAP: '<>';
ENDIAN_BYTE_SWAP: '<->';
EXP: '**';
SH1R: '>>>';
SH1L: '<<<';
SH0R: '>>';
SH0L: '<<';
ROTR: '>->';
ROTL: '<-<';

LOGIC_AND: '&&' | 'and';
LOGIC_NAND: '!&&' | 'nand';
LOGIC_OR: '||' | 'or';
LOGIC_NOR: '!||' | 'nor';
LOGIC_XOR: '^^' |'xor';
LOGIC_XNOR: '!^^' | 'xnor';

NAND: '!&';
XNOR: '!^';
NOR:  '!|';

SPACESHIP: '<=>';
EQ:        '==';
NEQ:       '!=';
LTE:       '<=';
GTE:       '>=';

MUL: '*';
DIV: '/';
MOD: '%';
PLUS: '+';
MINUS: '-';
LOGIC_NOT: '!' | 'not';
AND: '&';
XOR: '^';
OR: '|';
GT: '>';
LT: '<';
BIN_NOT: '~';
ASSIGN: '=';

/* Literals */
LIT_INT: (DEC_NUMBER | HEX_NUMBER | BIN_NUMBER | '0');
LIT_DOUBLE: ([1-9][0-9]* | '0')? '.' [0-9]+ ('e' [1-9][0-9]*)?;
LIT_NULL: 'null';
LIT_TRUE: 'true';
LIT_FALSE: 'false';
LIT_CHAR: '\'' (UNICODE_CHAR_LIT | ~[\\'] | '\\' .) '\'';
BACKTICK_OPEN: ID? '`' -> pushMode(MultiLineString);
QUOTE_OPEN: '"'        -> pushMode(LineString);

/* ID */
ID: [a-zA-Z_][a-zA-Z0-9_]*;

mode LineString;
QUOTE_CLOSE: '"'                               -> popMode;
LINE_STR_ESCAPED_CHAR: STR_ESCAPED_CHAR_FRAG   -> type(STR_ESCAPED_CHAR);
LINE_STR_TEXT: ~["$\\\n\r]+                    -> type(STR_TEXT);
LINE_STR_DOLLAR: '$' '$'                       -> type(STR_DOLLAR);
LINE_STR_REF: INTERP_VAR                       -> type(STR_REF);
LINE_STR_EXPR_START: STR_EXPRESSION_START      -> pushMode(DEFAULT_MODE), type(STR_EXPR_START);
LINE_STR_NL: '\r'? '\n'                        -> popMode;

mode MultiLineString;
BACKTICK_CLOSE: '`'                            -> popMode;
MULTILINE_STR_TEXT: ~[$`]+                     -> type(STR_TEXT);
MULTILINE_STR_DOLLAR: '$$'                     -> type(STR_DOLLAR);
MULTILINE_STR_REF: INTERP_VAR                  -> type(STR_REF);
MULTILINE_STR_EXPR_START: STR_EXPRESSION_START -> pushMode(DEFAULT_MODE), type(STR_EXPR_START);
