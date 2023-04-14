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

fragment ESCAPE_SEQ:
  '\\' '\\'
  | '\\' '0'
  | '\\' '\''
  | '\\' '"'
  | '\\' '?'
  | '\\' 'a'
  | '\\' 'b'
  | '\\' 'f'
  | '\\' 'n'
  | '\\' 'r'
  | ('\\' ('\r' '\n'? | '\n'))
  | '\\' 't'
  | '\\' 'v';
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
fragment STR_ESACAPED_CHAR_FRAG: '\\' . | UNICODE_CHAR_LIT;
fragment UNICODE_CHAR_LIT: '\\u' HEX_QUAD;


DOC_COMMENT: '/**' .*? '*/'  -> channel(DOCUMENTATION);
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
LINE_COMMENT: '//' ~[\r\n]*  -> skip;
WS: [ \t\r\n]+               -> skip;
STATIC_ACCESS_OP: '::';
ACCESS_OP: '.' | '->';

LCURLY: '{';
RCURLY: '}';
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
INTERFACE: 'interface';

THIS: 'this';
VAR: 'var';

LOOP: 'loop';
FOR: 'for';
WHILE: 'while';
DO: 'do';

BREAK: 'break';
CONTINUE: 'continue';
RET: 'ret';

MUT: 'mut';
PUB: 'pub';
PRO: 'pro';
DEREF: '@';
ADDR: '&';
REF: '#';

IN: 'in';
EQ: '==';
ASSIGN: '=';
INCREMENT: '++';
PLUS: '+';
DECREMENT: '--';
MINUS: '-';
LOGIC_FLIP: '!!';
LOGIC_NOT: '!';
BIN_FLIP: '~~';
BIN_NOT: '~';
EXP: '**';
MUL: '*';
DIV: '/';
INTEGRAL_DIV: ':';
SH1R: '>>>';
SH0R: '>>';
SH1L: '<<<';
SH0L: '<<';

ROTL: '<-<';
ROTR: '>->';
ENDIAN_BIT_SWAP: '<->';
ENDIAN_BYTE_SWAP: '<=>';

ID: [a-zA-Z_][a-zA-Z0-9_]*;



mode LineString;
QUOTE_CLOSE: '"'                              -> popMode;
LINE_STR_TEXT: ~["$\\\n\r]+                   -> type(STR_TEXT);
LINE_STR_ESCAPED_CHAR: STR_ESACAPED_CHAR_FRAG -> type(STR_ESCAPED_CHAR);
LINE_STR_DOLLAR: '$' '$'                      -> type(STR_DOLLAR);
LINE_STR_REF: INTERP_VAR                      -> type(STR_REF);
LINE_STR_EXPR_START: STR_EXPRESSION_START     -> pushMode(DEFAULT_MODE), type(STR_EXPR_START);
LINE_STR_NL: '\r'? '\n'                       -> popMode;

mode MultiLineString;
BACKTICK_CLOSE: '`'                            -> popMode;
MULTILINE_STR_TEXT: ~[$`]+                     -> type(STR_TEXT);
MULTILINE_STR_DOLLAR: '$' '$'                  -> type(STR_DOLLAR);
MULTILINE_STR_REF: INTERP_VAR                  -> type(STR_REF);
MULTILINE_STR_EXPR_START: STR_EXPRESSION_START -> pushMode(DEFAULT_MODE), type(STR_EXPR_START);
