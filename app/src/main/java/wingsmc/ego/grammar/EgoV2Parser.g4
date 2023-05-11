parser grammar EgoV2Parser;

options {
    tokenVocab = EgoV2Lexer;
}

// TODO macros
// TODO literal modifiers eg. 9u

moduleFile:
    moduleDef
    importDefinition?
    exportDefinition?
    moduleMemberDefinition*
    EOF;

accessModifer
    : PUB
    | PRO
    ;
behaviourModifier
    : STATIC
    | VIRTUAL
    | OVERRIDE
    | ABSTRACT
    ;
typeModifier
    : AT  // dereference / reference
    | TAG // address of  / pointer
    ;
mutAndTypeModifiers: (MUT? typeModifier)+;

moduleDef: accessModifer? MODULE;
importDefinition: IMPORT importBlock;
exportDefinition: EXPORT exportBlock;
moduleMemberDefinition
    : field
    | functionDeclaration
    | classDeclaration
    | interfaceDeclaration
    | implementDeclaration
    | useStmt
    ;
useStmt: USE ID ASSIGN scopedIdentifier;
functionDeclaration: accessModifer? behaviourModifier* typeName? ID lambdaExpr;
classDeclaration: accessModifer? behaviourModifier* CLASS ID LCURLY
    (constructorDeclartation | functionDeclaration | field)*
    RCURLY;
interfaceDeclaration: accessModifer? INTERFACE ID LCURLY
    (functionDeclaration | functionHeader)*
    RCURLY;
implementDeclaration: accessModifer? scopedIdentifier IMPL VIRTUAL? scopedIdentifier LCURLY
    functionDeclaration*
    RCURLY;


scopedTypeIdentifier
    : ID (STATIC_ACCESS_OP ID)*
    | VAR
    ;
scopedIdentifier
    : ID (STATIC_ACCESS_OP ID)* 
    | THIS
    ;
globalScopeIdentifier: (STATIC_ACCESS_OP ID)+;
typeName: mutAndTypeModifiers? MUT? (scopedTypeIdentifier | toupleTypeDef);

field: accessModifer? behaviourModifier* (typeName ID | typeName? THIS);
parameter: typeName ID | AT MUT? THIS;

importBlock: LCURLY importItem* RCURLY;
importItem: (scopedIdentifier | globalScopeIdentifier)
    (AS scopedIdentifier)? importBlock? COMMA?;
exportBlock: LCURLY exportItem* RCURLY;
exportItem: scopedIdentifier (AS scopedIdentifier)? COMMA?;

lambdaExpr: functionParameters (blockStmt | returnStmt);
functionHeader: accessModifer? typeName? ID functionParameters;
constructorDeclartation: accessModifer? lambdaExpr;

toupleTypeDef: LCURLY scopedTypeIdentifierList? RCURLY;
functionParameters: LPAREN (parameter (COMMA parameter)* COMMA?)? RPAREN;
scopedTypeIdentifierList: scopedTypeIdentifier (COMMA scopedTypeIdentifier)* COMMA?;
assignment: ASSIGN expr;

tag: TAG ID;
returnStmt: RET expr;
blockStmt: LCURLY (stmt SEMI?)* RCURLY;
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
    | typeName ID assignment?                       #varDef
    | expr                                          #exprStmt
    ;

exprList: expr (COMMA expr)* COMMA?;
stringContent
    : STR_EXPR_START expr RCURLY
    | STR_REF
    | STR_DOLLAR
    | STR_TEXT
    | STR_ESCAPED_CHAR
    ;
literalExpr
    : QUOTE_OPEN stringContent* QUOTE_CLOSE         #singleLineStringLit
    | BACKTICK_OPEN stringContent* BACKTICK_CLOSE   #multiLineStringLit
    | LIT_INT                                       #int
    | LIT_DOUBLE                                    #double
    | LIT_NULL                                      #null
    | LIT_CHAR                                      #char
    | (LIT_TRUE | LIT_FALSE)                        #bool
    ;
expr
    // Basic values
    : literalExpr                                   #literal
    | scopedIdentifier                              #id
    | LSQUARE expr SEMI exprList? RSQUARE           #array
    | LSQUARE exprList? RSQUARE                     #list
    | LCURLY expr (COMMA expr)* COMMA? RCURLY       #touple
    | IF expr (blockStmt | expr)
        (ELSE (blockStmt | expr))?                  #if
    | lambdaExpr                                    #lambda
    | TAG LPAREN expr RPAREN                        #lambdaShorthand
    | TAG LIT_INT                                   #lambdaShorthandParam
    // Operators
    | LPAREN expr RPAREN                            #parensOp
    | expr RANGE ASSIGN? expr                       #range
    | expr ACCESS_OP ID                             #accessOp
    | (NEW | SHARED | UNIQUE | DELETE) expr         #memoryOp
    | <assoc= right> AT expr                        #derefOp
    | MUT expr                                      #mutOp
    | expr LSQUARE expr RSQUARE                     #indexOp
    | expr LPAREN exprList? RPAREN                  #fnCallOp
    | <assoc= right> TAG expr                       #addrOp
    |   ( INCREMENT | DECREMENT
        | BIN_FLIP | LOGIC_FLIP
        ) expr                                      #unaryAssignmentOp
    | <assoc= right> expr EXP expr                  #mathHighOp
    |   ( MINUS
        | BIN_NOT | LOGIC_NOT
        | ENDIAN_BIT_SWAP | ENDIAN_BYTE_SWAP
        ) expr                                      #unaryOp
    | expr (MUL | DIV | MOD) expr                   #mathMidOp
    | expr (PLUS | MINUS) expr                      #mathLowOp
    | expr
        ( SH1R | SH0R | SH1L | SH0L
        | ROTL | ROTR
        ) expr                                      #bitMoveOp
    | expr
        ( AND | NAND
        | XOR | XNOR
        | OR  | NOR
        ) expr                                      #bitwiseOp
    | expr
        ( SPACESHIP
        | LT | GT | LTE | GTE | EQ | NEQ
        ) expr                                      #comparisonOp
    | expr
        ( LOGIC_AND | LOGIC_NAND
        | LOGIC_XOR | LOGIC_XNOR
        | LOGIC_OR  | LOGIC_NOR
        ) expr                                      #logicOp
    | expr PIPE expr                                #pipe
    | expr IS scopedTypeIdentifier                  #is
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
        ) ASSIGN expr                               #assignOp
    | <assoc= right> expr
        (LT | GT | NEQ) COLON expr                  #assignComp
    | <assoc= right> expr assignment                #assign
    ;
