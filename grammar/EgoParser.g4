parser grammar EgoParser;

options {
  tokenVocab = EgoLexer;
}

program: fileLevelModuleDecl EOF;
nls: NL+;
eos: nls | SEMI nls?;
eoe: nls | COMMA nls?;
lcurly: LCURLY nls?;
rcurly: RCURLY eos?;
lparen: LPAREN nls?;
rparen: RPAREN nls?;

/* Module */
fileLevelModuleDecl: moduleName eos moduleBody;
moduleDecl: modAccess moduleName nls? lcurly importList rcurly;
moduleName: MODULE IDENTIFIER;
moduleBody: importDecl? memberDecl*;
importDecl: IMPORT nls? lcurly importList eos;
importDestruct: lcurly importDestructList RCURLY;
importList: (importItem eoe)* importItem? eoe?;
importDestructList: (importDestructItem eoe)* importDestructItem?;
importItem: (importDestruct FROM IDENTIFIER) | IDENTIFIER (AS IDENTIFIER)?;
importDestructItem: IDENTIFIER (AS IDENTIFIER)?;
memberDecl: moduleDecl | fieldDecl | propertyDecl | functionDecl | classDecl; // TODO more types

/* Variable */
variableDecl: modField* typename IDENTIFIER /*(ASSIGN expr)?*/ eos;

/* Field */
fieldDecl: modAccess? variableDecl;

/* Property */
propertyDecl: modAccess? modProperty* typename IDENTIFIER nls? lcurly propertyBodyDecl RCURLY /*(ASSIGN expr)?*/ eos;
propertyBodyDecl: (propertyGetterDecl | propertySetterDecl)?;
propertyGetterDecl: GET functionBody? eos;
propertySetterDecl: SET functionBody? eos;

/* Function */
functionDecl: modAccess? modFunction? typename? IDENTIFIER functionParamList functionBody;
functionAnonymDecl: functionParamList functionBody;
functionParamList: lparen (functionParam (eoe functionParam)* eoe)? rparen;
functionParam: typename IDENTIFIER;
functionBody: (nls? lcurly /*seqStmt*/ rcurly) /*| returnStmt */;

/* Constructor */
// constructorDecl: modAccess? IDENTIFIER constructorParamList constructorBody;

/* Destructor */

/* Class */
classDecl:
  modClass* STRUCT_CLASS IDENTIFIER nls? (ASSIGN nls? IDENTIFIER (eoe IDENTIFIER)*)? lcurly classBodyDecl nls? RCURLY nls?;
classBodyDecl:;

/* Types */
string: singleLineString | multiLineString | pureString;
singleLineString: QUOTE_OPEN stringContent* QUOTE_CLOSE;
multiLineString: TRIPLE_QUOTE_OPEN stringContent* TRIPLE_QUOTE_CLOSE;
pureString: QUOTE_OPEN STR_TEXT QUOTE_CLOSE;
stringContent: stringExpression | STR_REF | STR_TEXT | MULTILINE_STR_QUOTE | STR_ESCAPED_CHAR;
stringExpression: STR_EXPR_START .*? STR_EXPR_END; // TODO implement
typename:
  T_BOOL
  | T_INT_8
  | T_INT_16
  | T_INT_32
  | T_INT_64
  | T_UINT_8
  | T_UINT_16
  | T_UINT_32
  | T_UINT_64
  | T_FLOAT
  | T_DOUBLE
  | T_REAL
  | T_COMPLEX
  | T_VEC_2
  | T_VEC_3
  | T_VEC_4
  | T_MAT_2
  | T_MAT_3
  | T_MAT_4
  | T_CHAR
  | T_CHAR_16
  | T_STRING
  | T_VAR
  | M_CONST
  | T_VOID
  | IDENTIFIER
  | typename (AMP M_CONST?)?;

/* Modifiers */
modAccess: M_PUBLIC | M_PROTECTED | M_PRIVATE | M_INTERNAL;
modFunction: M_ABSTRACT | M_STATIC | M_VIRTUAL | M_OVERRIDE;
modField: M_STATIC | M_CONST | M_VOLATILE;
modProperty: M_STATIC | M_VOLATILE;
modClass: M_VIRTUAL | M_ABSTRACT | M_CONST;


/* Flow */
/*
seqStmt: stmt*;
block: LCURLY seq RCURLY;
stmt: block | whileStmt | doWhileStmt | forStmt | returnStmt;
whileStmt: F_WHILE expr stmt;
doWhileStmt: F_DO stmt F_WHILE expr;
forStmt: F_FOR forHeaderStmt stmt;
classBodyDeclStatement: memberDeclStatement | memberConstructorDecl;
memberFieldDecl: typeQualifier? typename IDENTIFIER | typeQualifier? typename ASSIGN expr;
forHeaderStmt:;
returnStmt: F_RETURN expr;
*/
assignStmt: IDENTIFIER ASSIGN expr;
expr: assignmentExpr;
coalescingExpr: expr NULL_COALESCE <assoc = right> expr;
assignmentExpr: IDENTIFIER opAssignment <assoc = right> expr;
opAssignment:
  ASSIGN
  | ADD_ASSIGN
  | SUB_ASSIGN
  | EXP_ASSIGN
  | MUL_ASSIGN
  | DIV_ASSIGN
  | MOD_ASSIGN
  | ROT_L_ASSIGN
  | ROT_R_ASSIGN
  | SH_L_S_ASSIGN
  | SH_R_S_ASSIGN
  | SH_L_ASSIGN
  | SH_R_ASSIGN
  | GT_ASSIGN
  | LT_ASSIGN
  | BIT_AND_ASSIGN
  | BIT_OR_ASSIGN
  | BIT_XOR_ASSIGN
  | LOG_AND_ASSIGN
  | LOG_OR_ASSIGN
  | LOG_XOR_ASSIGN
  | NULL_COALESCE_ASSIGN
  | NULL_NON_NULL_ASSIGN
  | NULL_COALESCE_MEMBER_ASSIGN
  | DOT_ASSIGN
  | ARROW_DEREF_ASSIGN
  | ARROW_ASSIGN
  | DOT_DEREF_ASSIGN;
unaryAssignments: AR_INCR | AR_DECR | BIT_NOT_NOT | LOG_NOT_NOT;
