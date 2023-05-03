parser grammar EgoParser;

options {
  tokenVocab = EgoLexer;
}

file: fileLevelModuleDecl;
eos: SEMI;
eoe: NL+ | COMMA ;





/* Identifiers, Access, and Namespacing */
variable: identifier | accessedStaticIdentifier;
identifier: THIS | SUPER | VALUE | FIELD | GLOBAL | MODULE | DEFAULT | IDENTIFIER;
accessedStaticIdentifier: identifier templateUse? (SCOPE accessedStaticIdentifier)?;
templateDecl: LT identifierListWithInheritance GT;
templateUse: LT typenameList GT;





/* Modifiers */
modAccess: M_PUBLIC | M_PROTECTED;
modFunction: M_ABSTRACT | M_STATIC | M_VIRTUAL | M_OVERRIDE | M_ASYNC;
modField: M_STATIC | M_MUT | M_CONST;
modParam: M_MUT;
modProperty: M_STATIC;
modClass: M_VIRTUAL | M_ABSTRACT | M_SEALED;





/* Module */
fileLevelModuleDecl: (moduleName eos)? moduleContent EOF;
moduleDecl: modAccess? moduleName LCURLY moduleContent RCURLY;
moduleName: MODULE IDENTIFIER;
moduleContent: importDecl? moduleMemberDecl* exportDecl?;
importDecl: IMPORT importDestructure;
importItem: accessedStaticIdentifier (AS (IDENTIFIER | DEFAULT))? importDestructure?;
exportDecl: EXPORT exportStructure;
exportItem: accessedStaticIdentifier (AS (IDENTIFIER | DEFAULT))?;
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

destructureObject: modField* T_LET destructObject ASSIGN expr eos;
destructObject: LCURLY destructObjectList RCURLY;
destructObjectList: (destructObjectItem eoe)* destructObjectItem? eoe?;
destructObjectItem: IDENTIFIER (AS IDENTIFIER | (destructObject | destructArray))?;

destructureArray: modField* T_LET destructArray ASSIGN expr eos;
destructArray: LSQUARE destructArrayList RSQUARE;
destructArrayList:  (destructArrayItem eoe)* destructArrayItem? eoe?;
destructArrayItem:
  IDENTIFIER (destructObject | destructArray) # furtherDestructure
  | ELLIPSIS IDENTIFIER                       # destructRest
  | IDENTIFIER                                # destructId;





/* Property */
propertyDecl:
  modAccess? modProperty* typename IDENTIFIER ( ASSIGN  expr)?  LCURLY propertyGetterDecl? propertySetterDecl? RCURLY;
propertyGetterDecl: annotation? GET (functionBody | eos)?;
propertySetterDecl: annotation? SET (functionBody | eos)?;





/* Function */
functionDecl: modAccess? modFunction* typename? IDENTIFIER templateDecl? functionAnonymDecl;
functionAnonymDecl: functionParams functionBody;
functionParam: modParam? typename ELLIPSIS? IDENTIFIER;
functionBody:  (blockStmt | returnStmt);





/* Class */
classDecl: modAccess? modClass* STRUCT_CLASS IDENTIFIER templateDecl? classInheritance? classStructure;
classInheritance: IS  inheritanceList;
classBodyDecl: (annotation? constructorDecl | moduleMemberDecl | annotation? destructorDecl)*;
constructorDecl: modAccess? AT? AT? constructorParams blockStmt?;
constructorParam: modAccess? functionParam;
destructorDecl: BIT_NOT functionBody | M_VIRTUAL BIT_NOT functionBody?;





/* Blocks */
importDestructure: LCURLY ((importItem eoe)* importItem? eoe?) RCURLY;
exportStructure: LCURLY ((exportItem eoe)* exportItem? eoe?) RCURLY;
classStructure: LCURLY classBodyDecl RCURLY;
blockStmt: LCURLY seqStmt RCURLY;
functionCallParams: LPAREN exprList RPAREN;
parenExpr: LPAREN expr RPAREN;
constructorParams: LPAREN constructorParamList RPAREN;
functionParams: LPAREN funcParamList RPAREN;
arrayLiteral: LSQUARE exprList RSQUARE;
arrSize: LSQUARE expr RSQUARE;
annotation: LSQUARE staticIdentifierList RSQUARE;
/* Comma/NL separated lists */
staticIdentifierList: (accessedStaticIdentifier eoe)* accessedStaticIdentifier? eoe?;
inheritanceList: (IDENTIFIER templateUse? eoe)* (IDENTIFIER templateUse?)? eoe?;
identifierListWithInheritance: (typename? IDENTIFIER eoe)* (typename? IDENTIFIER)? eoe?;
exprList: ((expr eoe)* expr? eoe?);
constructorParamList: (constructorParam eoe)* constructorParam? eoe?;
funcParamList: (functionParam eoe)* functionParam? eoe?;
typenameList: ((typename | IS_NULL) eoe)* (typename | IS_NULL)? eoe?;





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
  | F_WHILE tag? parenExpr stmt
  | F_DO stmt F_WHILE tag? parenExpr eos
  | F_FOR tag? forHeader stmt
  | asmBlock 
  | trickleStmt
  | F_CONTINUE tag? eos
  | F_BREAK tag? eos
  | F_GOTO IDENTIFIER eos
  | F_TRY parenExpr?  stmt (F_CATCH parenExpr  stmt)* (F_FINALLY  stmt)?
  | ifStmt
  | switchStmt
  | destructureArray
  | destructureObject
  | returnStmt
  | evalStmt
  | yieldStmt
  | expr eos
  | tag eos;
returnStmt: F_RETURN tag? expr? eos;
evalStmt: F_EVAL tag? expr eos;
yieldStmt: F_YIELD expr eos;
trickleStmt: F_TRICKLE eos;
forHeader: LPAREN typename? IDENTIFIER (IN | OF) expr RPAREN;
ifStmt: F_IF tag? parenExpr  stmt (F_ELSE stmt)?;
switchStmt: F_SWITCH tag? parenExpr  switchBody;
switchBody: LCURLY switchCase* RCURLY;
switchCase: (parenExpr | expr) stmt;
asmBlock: ASM_START (ASM_CONTENT | asmBlock)* RCURLY;
tag: HASH IDENTIFIER;





expr:
  (AT | BIT_AND) expr                                                                                               # ptrRef
  | expr  (DOT | DOT_DEREF | COALESCE_MEMBER | ARROW | ARROW_DEREF | COALESCE_PTR_MEMBER | SCOPE)  IDENTIFIER # access
  | (AR_INCR | AR_DECR | BIT_NOT | BIT_NOT_NOT | LOG_NOT | LOG_NOT_NOT | ADD | SUB) expr                            # preUnary
  | expr functionCallParams                                                                                         # funcall
  | expr CALL_CHAIN expr                                                                                            # callChain
  | <assoc= right> expr  EXP  expr                                                                            # exp
  | expr  (MUL | DIV | MOD)  expr                                                                             # mulDivMod
  | expr  (ADD | SUB)  expr                                                                                   # addSub
  | expr  (SH_L | SH_R | SH_LS | SH_RS | ROT_L | ROT_R | SWAP_BITS | SWAP_BYTES | SWAP_BITS_AND_BYTES)  expr  # shRot
  | expr  (EQ | NEQ | LT | GT | LTE | GTE | SPACESHIP)  expr                                                  # compare
  | expr  (BIT_AND | BIT_OR | BIT_XOR)  expr                                                                  # bitL
  | expr  (BIT_NAND | BIT_NOR | BIT_XNOR)  expr                                                               # bitLN
  | expr  (LOG_AND | LOG_OR | LOG_XOR)  expr                                                                  # log
  | expr  (LOG_NAND | LOG_NOR | LOG_XNOR)  expr                                                               # logNot
  | <assoc= right> expr  COALESCE  expr                                                                       # coalesce
  | expr  (IS | IS_NOT)  accessedStaticIdentifier                                                             # typecheck
  | expr  AS  typename                                                                                        # cast
  | <assoc= right> expr opAssignment expr                                                                           # assignment
  | parenExpr                                                                                                       # parens
  | switchStmt                                                                                                      # switchExpr
  | ifStmt                                                                                                          # ifExpr
  | (NEW | UNIQUE | SHARED) accessedStaticIdentifier functionCallParams                                             # alloc
  | (NEW | UNIQUE | SHARED)? accessedStaticIdentifier arrSize+                                                      # arrAlloc
  | expr (RANGE | ELLIPSIS) expr ((M_MUT)? STEP expr)?                                                              # rangeExpr
  | DELETE expr                                                                                                     # delete
  | arrayLiteral                                                                                                    # arrayInitList
  | ELLIPSIS expr                                                                                                   # spread
  | F_AWAIT expr                                                                                                    # await
  | F_THROW expr                                                                                                    # throwExpr
  | SIZEOF expr                                                                                                     # sizeofExpr
  | variableDecl                                                                                                    # varDeclExpr
  | literal                                                                                                         # litExpr
  | variable                                                                                                        # varExpr;





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
  | EQ_ASSIGN
  | BIT_AND_ASSIGN
  | BIT_OR_ASSIGN
  | BIT_XOR_ASSIGN
  | LOG_AND_ASSIGN
  | LOG_OR_ASSIGN
  | LOG_XOR_ASSIGN
  | COALESCE_ASSIGN
  | NON_NULL_ASSIGN
  | COALESCE_MEMBER_ASSIGN
  | COALESCE_PTR_MEMBER_ASSIGN
  | DOT_DEREF_ASSIGN
  | ARROW_DEREF_ASSIGN
  | DOT_ASSIGN
  | ARROW_ASSIGN;
typename:
  T_VOID
  | T_BOOL
  | T_INT_8
  | T_INT_16
  | T_INT_32
  | T_INT_64
  | T_INT_128
  | T_UINT_8
  | T_UINT_16
  | T_UINT_32
  | T_UINT_64
  | T_UINT_128
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
  | T_REGEX
  | T_LET
  | M_MUT
  | typename IS_NULL
  | typename AT
  | accessedStaticIdentifier
  | typename (M_MUT? BIT_AND)+
  | typename (LSQUARE RSQUARE)+;
