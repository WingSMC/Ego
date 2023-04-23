parser grammar EgoV2Parser;

options {
    tokenVocab = EgoV2Lexer;
}

moduleFile: moduleDef? importDefinition? moduleMemberDefinitions? EOF;

moduleDef: MODULE ID;
moduleMemberDefinitions: (functionDeclaration | classDeclaration)+;

accessModifer
    : PUB
    | PRO
    ;
typeModifier
    : AT
    | ADDR
    ;

scopedIdentifier: (ID (STATIC_ACCESS_OP ID)* | (STATIC_ACCESS_OP ID)+) | THIS;
accessedIdentifier: scopedIdentifier (ACCESS_OP ID)*;
// TODO repeating  mut & mut like const * const in c++
typeName: typeModifier? MUT? (scopedIdentifier | VAR | toupleTypeDef);
field: accessModifer? (typeName ID | THIS);


importDefinition: IMPORT importBlock;
importBlock: LCURLY importList? RCURLY;
importList: importItem (COMMA importItem)* COMMA?;
importItem: scopedIdentifier (AS ID)? importBlock?;

functionDeclaration: accessModifer? typeName? ID functionParameters block;
classDeclaration: accessModifer? CLASS ID toupleWithNamedFields;
// TODO interface & export & implementation & generators & alias

toupleTypeDef: LCURLY scopedIdentifierList? RCURLY;
toupleExpr: LCURLY expr (COMMA expr)+ COMMA? RCURLY;
toupleWithNamedFields: LCURLY commaSeparatedFieldList? RCURLY;
functionParameters: LPAREN commaSeparatedFieldList? RPAREN;

scopedIdentifierList:    scopedIdentifier (COMMA scopedIdentifier)* COMMA?;
exprList:                expr (COMMA expr)* COMMA?;
commaSeparatedFieldList: field (COMMA field)* COMMA?;

block: LCURLY stmt* RCURLY;
variableDefinition: (accessModifer)* typeName ID;

stmt
    : block                                                       #blockStmt
    | BREAK ID?                                                   #breakStmt
    | CONTINUE ID?                                                #continueStmt
    | RET expr                                                    #returnStmt
    | LOOP expr? (SEMI ID)? block                                 #loopStmt
    | FOR ID IN expr (SEMI ID)? block                             #forStmt
    | WHILE expr block                                            #whileStmt
    | DO block WHILE expr SEMI                                    #dowhileStmt
    | variableDefinition                                          #variableDefinitionStmt
    | expr                                                        #exprStmt
    ;


assignment: ASSIGN expr;
literal
    :  #number
    ;

expr
	: LPAREN expr RPAREN                                                  #parens
	| accessModifer accessedIdentifier                              #modified
	| (INCREMENT | DECREMENT | BIN_FLIP | LOGIC_FLIP) accessedIdentifier                #unaryAssignment
	| <assoc= right> expr EXP expr                                 #mathHigh
	| (PLUS | MINUS | BIN_NOT | LOGIC_NOT | ENDIAN_BIT_SWAP | ENDIAN_BYTE_SWAP) accessedIdentifier    #unary
	| expr (MUL | INTEGRAL_DIV | DIV) expr                                   #mathMid
	| expr (PLUS | MINUS) expr                                         #mathLow
	| expr (SH1R | SH0R | SH1L | SH0L | ROTL | ROTR) expr                #bitMove
	| variableDefinition assignment                                 #defAssign
    | accessedIdentifier assignment                                 #assign
	| toupleExpr                                                    #touple
	| accessedIdentifier                                            #access
	;
