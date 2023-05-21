grammar Ego;

prog: functionDefinition*;

functionDefinition: type identifier '(' (parameter (',' parameter)* ','?)? ')' block;
parameter: type identifier;
type: identifier;
identifier: ID;

block: '{' statement* '}';
statement
    : 'ret' expression?                     #returnStatement
    | block                                 #blockStatement
    | 'if' condition statement ('else' statement)? #ifStatement
    | expression                            #expressionStatement
    ;

condition: expression;

expression
    : expression '*' expression #mul
    | expression '-' expression #sub
    | expression '+' expression #add
    | expression '/' expression #div
    | expression '%' expression #mod
    | expression '<=' expression #le
    | expression '<' expression  #lt
    | expression '>=' expression #ge
    | expression '>' expression  #gt
    | expression '==' expression #eq
    | expression '!=' expression #ne
    | identifier '(' (expression (',' expression)* ','?)? ')' #funcCall
    | 'if' condition statement 'else' statement #ifExpression
    | '(' expression ')'        #parens
    | identifier                #id
    | NUM                       #num
    ;

ID: [a-zA-Z_][a-zA-Z0-9_]*;
NUM: [0-9]+;
COMMENT: '//' ~[\r\n]* -> skip;
ML_COMMENT: '/*' .*? '*/' -> skip;
WS: [ \t\n\r]+ -> skip;
