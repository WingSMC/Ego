parser grammar EgoParser;

options {
  tokenVocab= EgoLexer;
}

program: fileLevelModuleDecl;
nls: NL*;
eos: NL+ | nls SEMI nls;
eoe: NL+ | nls COMMA nls;
lcurly: LCURLY nls;
rcurly: RCURLY nls;
lsquare: LSQUARE nls;
rsquare: RSQUARE nls;
lparen: LPAREN nls;
rparen: RPAREN nls;
langle: LT nls;
rangle: GT nls;





/* Identifiers, Access, and Namespacing */
variable: identifier | accessedStaticIdentifier;
identifier: THIS | SUPER | VALUE | FIELD | GLOBAL | MODULE | DEFAULT | IDENTIFIER;
accessedStaticIdentifier: identifier templateUse? (SCOPE accessedStaticIdentifier)?;
templateDecl: langle identifierListWithInheritance rangle;
templateUse: langle typenameList rangle;





/* Modifiers */
modAccess: M_PUBLIC | M_PROTECTED | M_PRIVATE | M_INTERNAL;
modFunction: M_ABSTRACT | M_STATIC | M_VIRTUAL | M_OVERRIDE | M_ASYNC;
modField: M_STATIC | M_CONST | M_VOLATILE;
modParam: M_CONST;
modProperty: M_STATIC | M_VOLATILE;
modClass: M_VIRTUAL | M_ABSTRACT | M_CONST;





/* Module */
fileLevelModuleDecl: nls (moduleName eos)? moduleContent EOF;
moduleDecl: modAccess? moduleName nls lcurly moduleContent rcurly;
moduleName: MODULE IDENTIFIER;
moduleContent: importDecl? moduleMemberDecl* exportDecl?;
importDecl: IMPORT nls importDestructure nls;
importItem: accessedStaticIdentifier (AS (IDENTIFIER | DEFAULT))? importDestructure?;
exportDecl: EXPORT nls exportStructure;
exportItem: accessedStaticIdentifier (AS IDENTIFIER)?;
moduleMemberDecl: annotation? moduleMember;
moduleMember:
  moduleDecl     # module
  | classDecl    # class
  | fieldDecl    # field
  | propertyDecl # property
  | functionDecl # function
  | aliasDecl    # alias;





/* Alias */
aliasDecl: modAccess? STRUCT_ALIAS ASSIGN IDENTIFIER (typename | TYPEOF expr);





/* Variable and Fields */
fieldDecl: modAccess? variableDecl eos;
variableDecl: modField* typename IDENTIFIER (ASSIGN expr)?;

destructureObject: modField* T_VAR destructObject ASSIGN expr eos;
destructObject: lcurly destructObjectList rcurly;
destructObjectList: nls (destructObjectItem eoe)* destructObjectItem? eoe?;
destructObjectItem: IDENTIFIER (AS IDENTIFIER | (destructObject | destructArray))?;

destructureArray: modField* T_VAR destructArray ASSIGN expr eos;
destructArray: lsquare destructArrayList rsquare;
destructArrayList: nls (destructArrayItem eoe)* destructArrayItem? eoe?;
destructArrayItem:
  IDENTIFIER (destructObject | destructArray) # furtherDestructure
  | ELLIPSIS IDENTIFIER                       # destructRest
  | IDENTIFIER                                # destructId;





/* Property */
propertyDecl:
  modAccess? modProperty* typename IDENTIFIER (nls ASSIGN nls expr)? nls lcurly propertyGetterDecl? propertySetterDecl? rcurly;
propertyGetterDecl: annotation? GET (functionBody | eos)?;
propertySetterDecl: annotation? SET (blockStmt | eos)?;





/* Function */
functionDecl: modAccess? modFunction* typename? IDENTIFIER templateDecl? functionAnonymDecl;
functionAnonymDecl: functionParams functionBody;
functionParam: modParam? typename ELLIPSIS? IDENTIFIER;
functionBody: nls (blockStmt | returnStmt);





/* Class */
classDecl: modAccess? modClass* STRUCT_CLASS IDENTIFIER templateDecl? classInheritance? classStructure;
classInheritance: IS nls inheritanceList;
classBodyDecl: (annotation? constructorDecl | moduleMemberDecl | annotation? destructorDecl)*;
constructorDecl: modAccess? AT? AT? constructorParams functionBody?;
constructorParam: modAccess? functionParam;
destructorDecl: BIT_NOT functionBody | M_VIRTUAL BIT_NOT functionBody?;





/* Blocks */
importDestructure: lcurly ((importItem eoe)* importItem? eoe?) RCURLY;
exportStructure: lcurly ((exportItem eoe)* exportItem? eoe?) rcurly;
classStructure: lcurly classBodyDecl rcurly;
blockStmt: lcurly seqStmt rcurly;
functionCallParams: lparen exprList RPAREN;
parenExpr: lparen expr RPAREN;
constructorParams: lparen constructorParamList rparen;
functionParams: lparen funcParamList rparen;
arrayLiteral: lsquare exprList RSQUARE;
arrSize: lsquare expr RSQUARE;
annotation: lsquare staticIdentifierList rsquare;
/* Comma/NL separated lists */
staticIdentifierList: (accessedStaticIdentifier eoe)* accessedStaticIdentifier? eoe?;
inheritanceList: (IDENTIFIER templateUse? eoe)* (IDENTIFIER templateUse?)? eoe?;
identifierListWithInheritance: (IDENTIFIER (IS accessedStaticIdentifier)? eoe)* (
    IDENTIFIER (IS accessedStaticIdentifier)?
  )? eoe?;
exprList: ((expr eoe)* expr? eoe?);
constructorParamList: (constructorParam eoe)* constructorParam? eoe?;
funcParamList: (functionParam eoe)* functionParam? eoe?;
typenameList: (typename eoe)* typename? eoe?;





/* Types */
literal: string | LIT_INT | LIT_DOUBLE | LIT_NULL | LIT_CHAR | bool;
string: pureString | singleLineString | multiLineString;
bool: LIT_TRUE | LIT_FALSE;
singleLineString: QUOTE_OPEN stringContent* QUOTE_CLOSE;
multiLineString: BACKTICK_OPEN stringContent* BACKTICK_CLOSE;
pureString: QUOTE_OPEN (STR_TEXT | STR_ESCAPED_CHAR)* QUOTE_CLOSE | BACKTICK_OPEN STR_TEXT? BACKTICK_CLOSE;
stringContent: stringExpression | STR_REF | STR_DOLLAR | STR_TEXT | STR_ESCAPED_CHAR;
stringExpression: STR_EXPR_START expr RCURLY;





/* Flow */
seqStmt: stmt*;
stmt:
  blockStmt
  | F_WHILE parenExpr stmt
  | F_DO stmt F_WHILE parenExpr eos
  | F_FOR forHeader stmt
  | ASM LCURLY ASM_CONTENT rcurly
  | F_TRICKLE eos
  | F_CONTINUE (HASH IDENTIFIER) eos
  | F_BREAK (HASH IDENTIFIER) eos
  | F_GOTO IDENTIFIER eos
  | F_TRY parenExpr? nls stmt (F_CATCH parenExpr nls stmt)* (F_FINALLY nls stmt)?
  | ifStmt
  | switchStmt
  | destructureArray
  | destructureObject
  | returnStmt
  | evalStmt
  | yieldStmt
  | expr eos;
returnStmt: F_RETURN expr? eos;
evalStmt: F_EVAL expr eos;
yieldStmt: F_YIELD expr eos;
forHeader: lparen T_VAR? IDENTIFIER (IN | OF) (range | expr) rparen;
ifStmt: F_IF parenExpr nls stmt (F_ELSE stmt)?;
switchStmt: F_SWITCH parenExpr nls switchBody;
switchBody: lcurly switchCase* rcurly;
switchCase: (parenExpr | expr) stmt;
range: expr RANGE expr ((M_CONST)? STEP expr)?;





expr:
  expr nls (ARROW | ARROW_DEREF | DOT | DOT_DEREF | COALESCE_MEMBER | SCOPE) nls IDENTIFIER # access
  | (AT | BIT_AND) expr                                                                     # ptrRef
  | (AR_INCR | AR_DECR | BIT_NOT | BIT_NOT_NOT | LOG_NOT | LOG_NOT_NOT | ADD | SUB) expr    # preUnary
  | expr functionCallParams                                                                 # funcall
  | <assoc= right> expr nls EXP nls expr                                                    # exp
  | expr nls (MUL | DIV | MOD) nls expr                                                     # mulDivMod
  | expr nls (ADD | SUB) nls expr                                                           # addSub
  | expr nls (SH_L | SH_R | SH_LS | SH_RS | ROT_L | ROT_R) nls expr                         # shRot
  | expr nls (EQ | NEQ | LT | GT | LTE | GTE) nls expr                                      # compare
  | expr nls (BIT_AND | BIT_NAND) nls expr                                                  # bitAnd
  | expr nls (BIT_OR | BIT_NOR) nls expr                                                    # bitOr
  | expr nls (BIT_XOR | BIT_XNOR) nls expr                                                  # bitXor
  | expr nls (LOG_AND | LOG_NAND) nls expr                                                  # logAnd
  | expr nls (LOG_OR | LOG_NOR) nls expr                                                    # logOr
  | expr nls (LOG_XOR | LOG_XNOR) nls expr                                                  # logXor
  | <assoc= right> expr nls COALESCE nls expr                                               # coalesce
  | expr nls (IS | IS_NOT) nls accessedStaticIdentifier                                     # typecheck
  | expr nls AS nls typename                                                                # cast
  | <assoc= right> expr opAssignment expr                                                   # assignment
  | parenExpr                                                                               # parens
  | switchStmt                                                                              # switchExpr
  | ifStmt                                                                                  # ifExpr
  | (NEW | UNIQUE | SHARED)? accessedStaticIdentifier functionCallParams                    # alloc
  | (NEW | UNIQUE | SHARED)? accessedStaticIdentifier arrSize+                              # arrAlloc
  | DELETE expr                                                                             # delete
  | arrayLiteral                                                                            # arrayInitList
  | ELLIPSIS expr                                                                           # spread
  | F_AWAIT expr                                                                            # await
  | F_THROW expr                                                                            # throwExpr
  | SIZEOF expr                                                                             # sizeofExpr
  | variableDecl                                                                            # varDeclExpr
  | literal                                                                                 # litExpr
  | variable                                                                                # varExpr;





/* Listings */
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
  | COALESCE_ASSIGN
  | NON_NULL_ASSIGN
  | COALESCE_MEMBER_ASSIGN
  | DOT_ASSIGN
  | ARROW_DEREF_ASSIGN
  | ARROW_ASSIGN
  | DOT_DEREF_ASSIGN;
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
  | typename IS_NULL
  | typename M_CONST? BIT_AND
  | typename AT
  | accessedStaticIdentifier
  | typename (LSQUARE RSQUARE)+;

// TODO
// operator overloading
// switch case & if ranges
// array init ranges
// events
// thread / corutine
// exception declarations
// annotation declaration
// record declaration
// enum declaration
// object declaration
// interface declaration

//? TEST
// $$ in string


//* NO POST UNARY
