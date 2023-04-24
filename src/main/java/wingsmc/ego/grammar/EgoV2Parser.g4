parser grammar EgoV2Parser;

options {
    tokenVocab = EgoV2Lexer;
}

moduleFile: moduleDef? importDefinition? moduleMemberDefinition* EOF;

moduleDef: MODULE ID;
moduleMemberDefinition
    : functionDeclaration
    | classDeclaration
    | useStmt
    ;

accessModifer
    : PUB
    | PRO
    ;
typeModifier
    : AT
    | TAG
    ;

scopedIdentifier: (ID (STATIC_ACCESS_OP ID)* | (STATIC_ACCESS_OP ID)+) | THIS;
typeName: MUT? (typeModifier MUT?)* (scopedIdentifier | VAR | toupleTypeDef);
field: accessModifer? (typeName ID | THIS);

importDefinition: IMPORT importBlock;
importBlock: LCURLY importItem* RCURLY;
importItem: scopedIdentifier (AS ID)? importBlock?;

useStmt: USE ID ASSIGN scopedIdentifier;

lambdaExpr: functionParameters (blockStmt | returnStmt);
functionDeclaration: accessModifer? typeName? ID lambdaExpr;

classDeclaration: accessModifer? CLASS ID toupleWithNamedFields;
// TODO interface & export & implementation

toupleTypeDef: LCURLY scopedIdentifierList? RCURLY;
toupleWithNamedFields: LCURLY commaSeparatedFieldList? RCURLY;
functionParameters: LPAREN commaSeparatedFieldList? RPAREN;
scopedIdentifierList:    scopedIdentifier (COMMA scopedIdentifier)* COMMA?;
commaSeparatedFieldList: field (COMMA field)* COMMA?;
assignment: ASSIGN expr;

tag: TAG ID;
returnStmt: RET expr;
blockStmt: LCURLY (stmt SEMI?)* RCURLY;
variableDefinitionStmt: typeName ID;
stmt
    : blockStmt                                     #block
    | useStmt                                       #use
    | BREAK ID?                                     #break
    | CONTINUE ID?                                  #continue
    | returnStmt                                    #return
    | YIELD expr                                    #yield
    | ID COLON                                      #label
    | JMP ID                                        #jmp
    | LOOP tag? expr? (SEMI ID)? blockStmt          #loop
    | FOR tag? MUT? ID IN expr (SEMI ID)? blockStmt #for
    | WHILE tag? expr blockStmt                     #while
    | DO tag? blockStmt WHILE expr SEMI             #dowhile
    | variableDefinitionStmt assignment?            #varDef
    | expr                                          #exprStmt
    ;

// TODO literal modifier eg. 9u
exprList: expr (COMMA expr)* COMMA?;
stringContent
    : STR_EXPR_START expr RCURLY
    | STR_REF
    | STR_DOLLAR
    | STR_TEXT
    | STR_ESCAPED_CHAR
    ;
literalExpr
    : QUOTE_OPEN stringContent* QUOTE_CLOSE       #singleLineStringLit
    | BACKTICK_OPEN stringContent* BACKTICK_CLOSE #multiLineStringLit
    | LIT_INT                                     #int
    | LIT_DOUBLE                                  #double
    | LIT_NULL                                    #null
    | LIT_CHAR                                    #char
    | (LIT_TRUE | LIT_FALSE)                      #bool
    ;
expr
    // Basic values
    : literalExpr                                #literal
    | scopedIdentifier                           #id
    | LSQUARE expr SEMI exprList? RSQUARE        #array
    | LSQUARE exprList? RSQUARE                  #list
    | LCURLY expr (COMMA expr)* COMMA? RCURLY    #touple
    | expr RANGE ASSIGN? expr                    #range
    | IF expr (blockStmt | expr)
        (ELSE (blockStmt | expr))?               #if
    | TAG LPAREN expr RPAREN                     #lambdaShorthand
    | TAG LIT_INT                                #lambdaShorthandParam
    // Operators
    | LPAREN expr RPAREN                         #parensOp
    | expr ACCESS_OP ID                          #accessOp
    | (NEW | SHARED | UNIQUE | DELETE) expr      #memoryOp
    | <assoc= right> AT expr                     #derefOp
    | expr LSQUARE expr RSQUARE                  #indexOp
    | expr LPAREN exprList? RPAREN               #fnCallOp
    | <assoc= right> TAG expr                    #addrOp
    |   ( INCREMENT | DECREMENT
        | BIN_FLIP | LOGIC_FLIP
        ) expr                                   #unaryAssignmentOp
    | <assoc= right> expr EXP expr               #mathHighOp
    |   ( MUT
        | MINUS
        | BIN_NOT | LOGIC_NOT
        | ENDIAN_BIT_SWAP | ENDIAN_BYTE_SWAP
        ) expr                                   #unaryOp
    | expr (MUL | DIV | MOD) expr                #mathMidOp
    | expr (PLUS | MINUS) expr                   #mathLowOp
    | expr
        ( SH1R | SH0R | SH1L | SH0L
        | ROTL | ROTR
        ) expr                                   #bitMoveOp
    | expr
        ( AND | NAND
        | XOR | XNOR
        | OR  | NOR
        ) expr                                   #bitwiseOp
    | expr
        ( SPACESHIP
        | LT | GT | LTE | GTE | EQ | NEQ
        ) expr                                   #comparisonOp
    | expr
        ( LOGIC_AND | LOGIC_NAND
        | LOGIC_XOR | LOGIC_XNOR
        | LOGIC_OR  | LOGIC_NOR
        ) expr                                   #logicOp
    | expr PIPE expr                             #pipe
    // Assignment
    | <assoc= right> expr 
        ( EXP | MUL | DIV | MOD
        | PLUS | MINUS
        | SH1R | SH0R | SH1L | SH0L
        | ROTL | ROTR
        | LOGIC_AND | LOGIC_NAND
        | LOGIC_XOR | LOGIC_XNOR
        | LOGIC_OR  | LOGIC_NOR
        | AND | NAND
        | XOR | XNOR
        | OR  | NOR
        ) ASSIGN expr                            #assignOp
    | <assoc= right> expr
        (LT | GT | NEQ) COLON expr               #assignComp
    | <assoc= right> expr assignment             #assign
    ;
