parser grammar EgoParser;

options {
  tokenVocab = EgoLexer;
}

program: fileLevelModuleDecl;
nls: NL+;
eos: nls | SEMI nls?;
eoe: nls | COMMA nls?;
lcurly: LCURLY nls?;
rcurly: RCURLY nls?;
lsquare: LSQUARE nls?;
rsquare: RSQUARE nls?;
lparen: LPAREN nls?;
rparen: RPAREN nls?;

/* Identifiers, Access, and Namespacing */
identifier: IDENTIFIER | THIS | SUPER | VALUE | FIELD;
memberAccessOperators: DOT | SCOPE | ARROW | DOT_DEREF | ARROW_DEREF | NULL_COALESCE_MEMBER;
accessedStaticIdentifier: IDENTIFIER (SCOPE IDENTIFIER)*;

/* Annotations */
annotation: lsquare (accessedStaticIdentifier eoe)* accessedStaticIdentifier? eoe? rsquare;

/* Module */
fileLevelModuleDecl: fileLevelModuleName moduleBody EOF;
fileLevelModuleName: moduleName eos;
moduleDecl: modAccess? moduleName nls? lcurly moduleBody rcurly;
moduleName: MODULE IDENTIFIER;
moduleBody: importDecl? moduleMemberDecl* exportDecl?;
importDecl: IMPORT nls? importDestructure nls?;
importDestructure: lcurly importList rcurly;
importList: (importItem eoe)* importItem? eoe?;
importItem: accessedStaticIdentifier (AS (IDENTIFIER | DEFAULT))? importDestructure?;
exportDecl: EXPORT nls? lcurly exportList rcurly;
exportList: (exportItem eoe)* exportItem? eoe?;
exportItem: accessedStaticIdentifier (AS IDENTIFIER)?;
moduleMemberDecl:
  annotation? (moduleDecl | classDecl | fieldDecl | propertyDecl); //  | functionDecl | classDecl; // TODO more types

/* Variable */
variableDecl: modField* typename IDENTIFIER (ASSIGN expr)? eos;

destructureObject: modField* T_VAR destructObject ASSIGN expr eos;
destructObject: lcurly destructObjectList rcurly;
destructObjectList: nls? (destructObjectItem eoe)* destructObjectItem? eoe?;
destructObjectItem: IDENTIFIER (AS IDENTIFIER | (destructObject | destructArray))?;

destructureArray: modField* T_VAR destructArray ASSIGN expr eos;
destructArray: lsquare destructArrayList rsquare;
destructArrayList: nls? (destructArrayItem eoe)* destructArrayItem? eoe?;
destructArrayItem: IDENTIFIER (destructObject | destructArray)?;

/* Field */
fieldDecl: modAccess? variableDecl;

/* Property */
propertyDecl: modAccess? modProperty* typename IDENTIFIER nls? (ASSIGN expr)? nls? lcurly propertyBodyDecl RCURLY eos;
propertyBodyDecl: propertyGetterDecl? propertySetterDecl?;
propertyGetterDecl: GET functionBody? eos?;
propertySetterDecl: SET functionBody? eos?;

/* Function */
functionDecl: modAccess? modFunction? typename? IDENTIFIER functionParamList functionBody;
functionAnonymDecl: functionParamList functionBody;
functionParamList: lparen (functionParam (eoe functionParam)* eoe)? rparen;
functionParam: typename IDENTIFIER;
functionBody: (nls? lcurly seqStmt rcurly) | returnStmt eos;

/* Constructor */
// constructorDecl: modAccess? IDENTIFIER constructorParamList constructorBody;

/* Destructor */

/* Class */
classDecl: modClass* STRUCT_CLASS IDENTIFIER (ASSIGN nls? IDENTIFIER (eoe IDENTIFIER)*)? lcurly classBodyDecl rcurly;
classBodyDecl: (constructorDecl | moduleMemberDecl)*;
constructorDecl: modAccess? constructorParamList functionBody?;
constructorParamList: lparen ((constructorParam eoe)* constructorParam? eoe?) rparen;
constructorParam: modAccess? functionParam;

/* Types */
literal: string | LIT_INT | LIT_DOUBLE | LIT_NULL | LIT_CHAR | boolean;
string: pureString | singleLineString | multiLineString;
boolean: LIT_TRUE | LIT_FALSE;
singleLineString: QUOTE_OPEN stringContent* QUOTE_CLOSE;
multiLineString: TRIPLE_QUOTE_OPEN stringContent* TRIPLE_QUOTE_CLOSE;
pureString: QUOTE_OPEN (STR_TEXT | STR_ESCAPED_CHAR)* QUOTE_CLOSE;
stringContent: stringExpression | STR_REF | STR_TEXT | MULTILINE_STR_QUOTE | STR_ESCAPED_CHAR;
stringExpression: STR_EXPR_START expr STR_EXPR_END;
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
  | typename (AMP M_CONST?)+;

/* Modifiers */
modAccess: M_PUBLIC | M_PROTECTED | M_PRIVATE | M_INTERNAL;
modFunction: M_ABSTRACT | M_STATIC | M_VIRTUAL | M_OVERRIDE;
modField: M_STATIC | M_CONST | M_VOLATILE;
modProperty: M_STATIC | M_VOLATILE;
modClass: M_VIRTUAL | M_ABSTRACT | M_CONST;

/* Flow */
seqStmt: stmt*;
stmt:
  blockStmt
  | whileStmt
  | doWhileStmt
  | forStmt
  | returnStmt
  | asmStmt
  | expr eos?; // | ifStmt | switchStmt | breakStmt | continueStmt;
returnStmt: F_RETURN expr eos?;
blockStmt: LCURLY seqStmt RCURLY;
whileStmt: F_WHILE expr stmt;
doWhileStmt: F_DO stmt F_WHILE expr;
forStmt: F_FOR forHeaderStmt stmt;
forHeaderStmt:; // TODO;
asmStmt: ASM LCURLY ASM_CONTENT rcurly;
expr:
  literal
  | identifier
  | expr AS typename                             // cast
  | <assoc = right> expr NULL_COALESCE expr      // coalesce
  | <assoc = right> identifier opAssignment expr // opAssignment
  | expr LPAREN (expr eoe)* expr? eoe? RPAREN    // functionCall
  | LPAREN expr RPAREN                           // parenthesis
  | expr AR_MUL expr                             ; // | exprList | exprParen | exprCall | exprMember | exprUnary | exprBinary | exprTernary | exprAssign | exprNew;
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
