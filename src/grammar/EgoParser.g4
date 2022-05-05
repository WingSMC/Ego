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
langle: COMP_LT nls?;
rangle: COMP_GT nls?;

/* Identifiers, Access, and Namespacing */
variable: identifier | accessedIdentifier | accessedStaticIdentifier  ;
identifier: THIS | SUPER | VALUE | FIELD | GLOBAL | MODULE | IDENTIFIER;
accessedIdentifier: identifier (SCOPE identifier)+;
accessedStaticIdentifier: (IDENTIFIER | GLOBAL | MODULE) (SCOPE IDENTIFIER)*;
templateDecl: langle identifierListWithInheritance rangle;
templateUse: langle typenameList rangle;

/* Modifiers */
modAccess: M_PUBLIC | M_PROTECTED | M_PRIVATE | M_INTERNAL;
modFunction: M_ABSTRACT | M_STATIC | M_VIRTUAL | M_OVERRIDE;
modField: M_STATIC | M_CONST | M_VOLATILE;
modParam: M_CONST;
modProperty: M_STATIC | M_VOLATILE;
modClass: M_VIRTUAL | M_ABSTRACT | M_CONST;


/* Module */
fileLevelModuleDecl: nls? fileLevelModuleName? moduleContent EOF;
fileLevelModuleName: moduleName eos;
moduleDecl: modAccess? moduleName nls? moduleBodyStructure;
moduleName: MODULE IDENTIFIER;
moduleContent: importDecl? moduleMemberDecl* exportDecl?;
importDecl: IMPORT nls? importDestructure nls?;
importItem: accessedStaticIdentifier (AS (IDENTIFIER | DEFAULT))? importDestructure?;
exportDecl: EXPORT nls? exportStructure;
exportItem: accessedStaticIdentifier (AS IDENTIFIER)?;
moduleMemberDecl:
  annotation? moduleMember;
moduleMember: //TODO more types
  moduleDecl #module
  | classDecl #class
  | fieldDecl #field
  | propertyDecl #property
  | functionDecl #function;



/* Variable and Fields */
fieldDecl: modAccess? variableDecl; // BOOKMARK
variableDecl: modField* typename IDENTIFIER (ASSIGN expr)? eos;

destructureObject: modField* T_VAR destructObject ASSIGN expr eos; // BOOKMARK
destructObject: lcurly destructObjectList rcurly;
destructObjectList: nls? (destructObjectItem eoe)* destructObjectItem? eoe?; // BOOKMARK
destructObjectItem: IDENTIFIER (AS IDENTIFIER | (destructObject | destructArray))?;

destructureArray: modField* T_VAR destructArray ASSIGN expr eos; // BOOKMARK
destructArray: lsquare destructArrayList rsquare;
destructArrayList: nls? (destructArrayItem eoe)* destructArrayItem? eoe?; // BOOKMARK
destructArrayItem: IDENTIFIER (destructObject | destructArray)?;



/* Property */
propertyDecl:
  modAccess? modProperty* typename IDENTIFIER (nls? ASSIGN nls? expr)? nls? lcurly propertyGetterDecl? propertySetterDecl? rcurly;
propertyGetterDecl: annotation? GET (functionBody | eos)?;
propertySetterDecl: annotation? SET (blockStmt | eos)?;



/* Function */
functionDecl: modAccess? modFunction* typename? IDENTIFIER templateDecl? functionAnonymDecl;
functionAnonymDecl: functionParams functionBody;
functionParam: modParam? typename IDENTIFIER;
functionBody: nls? (blockStmt | returnStmt eos);



/* Class */
classDecl: modAccess? modClass* STRUCT_CLASS IDENTIFIER templateDecl? classInheritance? classStructure;
classInheritance: IS nls? inheritanceList;
classBodyDecl: (annotation? constructorDecl | moduleMemberDecl | annotation? destructorDecl)*;
constructorDecl: modAccess? constructorParams functionBody?;
constructorParam: modAccess? functionParam;
destructorDecl: BIT_NOT functionBody | M_VIRTUAL BIT_NOT functionBody?;



/* Blocks */
importDestructure: lcurly importList RCURLY;
exportStructure: lcurly exportList rcurly;
moduleBodyStructure: lcurly moduleContent rcurly;
classStructure: lcurly classBodyDecl rcurly;
blockStmt: lcurly seqStmt rcurly;
constructorParams: lparen constructorParamList rparen;
functionParams: lparen funcParamList rparen;
functionCallParams: lparen functionCallParamList rparen;
annotation: lsquare staticIdentifierList rsquare;
/* Comma/NL separated lists */
importList: (importItem eoe)* importItem? eoe?;
exportList: (exportItem eoe)* exportItem? eoe?;
staticIdentifierList: (accessedStaticIdentifier eoe)* accessedStaticIdentifier? eoe?;
inheritanceList: (IDENTIFIER templateUse? eoe)* (IDENTIFIER templateUse?)? eoe?;
identifierListWithInheritance: (IDENTIFIER (IS accessedStaticIdentifier)? eoe)* (IDENTIFIER (IS accessedStaticIdentifier)?)? eoe?;
constructorParamList: (constructorParam eoe)* constructorParam? eoe?;
funcParamList: (functionParam eoe)* functionParam? eoe?;
functionCallParamList: (expr eoe)* expr? eoe?;
typenameList: (typename eoe)* typename? eoe?;



/* Types */
literal: string | LIT_INT | LIT_DOUBLE | LIT_NULL | LIT_CHAR | bool;
string: pureString | singleLineString | multiLineString;
bool: LIT_TRUE | LIT_FALSE;
singleLineString: QUOTE_OPEN stringContent* QUOTE_CLOSE;
multiLineString: TRIPLE_QUOTE_OPEN stringContent* TRIPLE_QUOTE_CLOSE;
pureString: QUOTE_OPEN (STR_TEXT | STR_ESCAPED_CHAR)* QUOTE_CLOSE;
stringContent: stringExpression | STR_REF | STR_TEXT | MULTILINE_STR_QUOTE | STR_ESCAPED_CHAR;
stringExpression: STR_EXPR_START expr RCURLY;
typename:
  T_VOID
  | T_BOOL
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
  | IDENTIFIER
  | typename (M_CONST? AMP)+
  | IDENTIFIER templateUse
  | accessedStaticIdentifier
  | TYPEOF expr
  | NULL_IS_NULL;



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
whileStmt: F_WHILE expr stmt;
doWhileStmt: F_DO stmt F_WHILE expr eos;
forStmt: F_FOR forHeaderStmt stmt;
forHeaderStmt:; // TODO;
asmStmt: ASM LCURLY ASM_CONTENT rcurly;
expr:
  literal                                        #lit
  | variable                                     #var
  | expr AS typename                             #cast
  | <assoc = right> expr NULL_COALESCE expr      #coalesce
  | <assoc = right> identifier opAssignment expr #assignment
  | expr functionCallParams                      #functionCall
  | lparen expr rparen                           #parenthesis
  | AT expr                                      #dereference
  | AMP expr                                     #addressOf
  | expr DOT IDENTIFIER                          #memberAccess
  | expr ARROW IDENTIFIER                        #pointerMemberAccess
  | expr AR_MUL expr                             #mul;                            // | exprList | exprParen | exprCall | exprMember | exprUnary | exprBinary | exprTernary | exprAssign | exprNew;
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
opMemberAccess: DOT | SCOPE | ARROW | DOT_DEREF | ARROW_DEREF | NULL_COALESCE_MEMBER;
opL1: AR_MUL | AR_DIV | AR_MOD;
opL2: AR_ADD | AR_MUL;

// TODO
// ops
// for
// switch
// branch
// generic
// arrays
// operator overloading
// ref
