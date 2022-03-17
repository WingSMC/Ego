grammar Ego;

test: NEW | ID;
program: seq;
seq: stmt*;
stmt:
	blockStmt
	| whileStmt
	| doWhileStmt
	| forStmt
	| returnStmt;
blockStmt: LCURLY seq RCURLY;
whileStmt: F_WHILE expr stmt;
doWhileStmt: F_DO stmt F_WHILE expr;
forStmt: F_FOR forHeaderStmt stmt;
forHeaderStmt:;
returnStmt: F_RETURN expr;
assignStmt: ID S_ASSIGN expr;
expr:;

/* Comment / Preproccessor */
PREPROCESSOR: '#' ~[\r\n]* -> skip;
BLOCK_COMMENT: '/*' .*? '*/' -> skip;
LINE_COMMENT: '//' ~[\r\n]* -> skip;

/* Typenames */
T_BOOL: 'bool';
T_INT_8: 'i8';
T_INT_16: 'i16';
T_INT_32: 'i32';
T_INT_64: 'i64';
T_UINT_8: 'u8';
T_UINT_16: 'u16';
T_UINT_32: 'u32';
T_UINT_64: 'u64';
T_FLOAT: 'float';
T_DOUBLE: 'double';
T_DECIMAL: 'decimal';
T_COMPLEX: 'complex';
T_CHAR: 'char';
T_CHAR_16: 'char16';
T_STRING: 'string';
T_AUTO: 'auto';
T_VOID: 'void';

/* Qualifier */
M_MUT: 'mut';
M_REF: 'ref';
M_VOLATILE: 'volatile';
M_STATIC: 'static';
M_OVERRIDE: 'override';
M_VIRTUAL: 'virtual';

/* Literals */
L_LONG: L_INT 'L';
L_INT: [1-9][0-9]* | '0x' [0-9a-f]+ | '0o' [0-7]+ | '0b' [01]+;
L_FLOAT: L_DOUBLE 'F';
L_DOUBLE: [1-9][0-9]* ('.' [0-9]+)?;
L_CHAR: '\'' . '\'';
L_STRING: '"' .*? '"';
L_NULL: 'null';
L_TRUE: 'true';
L_FALSE: 'false';

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
F_THROW: 'throw';
F_RETURN: '=>';

/* Operators */
NEW_ARR: 'new[' [0-9]+ ']';
UNIQUE_ARR: 'unique[' [0-9]+ ']';
SHARED_ARR: 'shared[' [0-9]+ ']';
DELETE_ARR: 'delete[]'; // TODO is this even needed?
NEW: 'new';
UNIQUE: 'unique';
SHARED: 'shared';
DELETE: 'delete';
IS: 'is';
IN: 'in';
AS: 'as';
AND: 'and';
OR: 'or';
XOR: 'xor';
NOT: 'not';

INCR: '++';
ADD_ASSIGN: '+:';
DECR: '--';
SUB_ASSIGN: '-:';
MUL_ASSIGN: '*:';
EXP: '**';
EXP_ASSIGN: '**:';
DIV: '/';
DIV_ASSIGN: '/:';
MOD: '%';
MOD_ASSIGN: '%:';
SHL: '<<';
SHL_ASSIGN: '<<:';
SHR: '>>';
SHR_ASSIGN: '>>:';
AND_ASSIGN: 'and:';
OR_ASSIGN: 'or:';
XOR_ASSIGN: 'xor:';
LOG: 'log';

NON_NULL_EXPR_CHAIN: '??';
NON_NULL_MEMBER_CHAIN: '.?';

LCURLY: '{';
RCURLY: '}';
LPAREN: '(';
RPAREN: ')';
LSQUARE: '[';
RSQUARE: ']';

S_LT: '<';
S_GT: '>';

EQ: '==';
NEQ: '!=';
LTE: '<=';
GTE: '>=';

S_AND: '&';
S_PIPE: '|';
S_CARET: '^';
S_DEG: '°';
S_DOLLAR: '$';
S_SCOPE: '::';
S_ASSIGN: ':';
S_DOT: '.';
S_ARROW: '->';
S_ASTERISK: '*';
S_PLUS: '+';
S_MINUS: '-';
S_TILDE: '~';

ID: [_a-zA-Z][_a-zA-Z0-9]*;
EOS: ';' | [\r\n][\r\n\t ]* ~(S_DOT | S_ARROW); // FIXME

NEW_LINE: [\r\n]+ -> skip;
WHITESPACE: [ \t]+ -> skip;
