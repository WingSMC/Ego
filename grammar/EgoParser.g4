parser grammar EgoParser;

options {
  tokenVocab = EgoLexer;
}

program: fileLevelModuleDeclStmt EOF;
nls: NL+;
eoe: nls | COMMA nls?;
eos: nls | SEMI nls?;

/* Module */
fileLevelModuleDeclStmt: moduleName moduleDeclStmt;
moduleDeclStmt: moduleImportDecl? moduleExportDecl? | memberDeclStatement;
moduleName: MODULE IDENTIFIER eos;
moduleImportDecl: IMPORT nls? LCURLY nls? importList RCURLY eos;
importList: (importItem eoe)* importItem?;
importItem: (importDestruct FROM IDENTIFIER) | IDENTIFIER (AS IDENTIFIER)?;
importDestruct: LCURLY nls? importDestructList RCURLY;
importDestructList: (importDestructItem eoe)* importDestructItem?;
importDestructItem: IDENTIFIER (AS IDENTIFIER)?;
moduleExportDecl: EXPORT nls? LCURLY nls? exportList RCURLY eos;
exportList: (exportItem eoe)* exportItem?;
exportItem: IDENTIFIER (AS IDENTIFIER)?;

/* Types */
string: singleLineString | multiLineString | pureString;
singleLineString: QUOTE_OPEN stringContent* QUOTE_CLOSE;
multiLineString: TRIPLE_QUOTE_OPEN stringContent* TRIPLE_QUOTE_CLOSE;
pureString: QUOTE_OPEN STR_TEXT QUOTE_CLOSE;
stringContent: stringExpression | STR_REF | STR_TEXT | MULTILINE_STR_QUOTE | STR_ESCAPED_CHAR;
stringExpression: STR_EXPR_START .*? STR_EXPR_END; // TODO: implement
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
  | T_VAL
  | M_VAR
  | T_VOID
  | IDENTIFIER;



moduleDeclStatement: memberDeclStatement | moduleImportDecl | moduleExportDecl;
memberDeclStatement:
  memberFieldDecl
  | memberPropertyDecl
  | memberMethodDecl
  | memberClassDecl
  | memberInterfaceDecl
  | memberEnumDecl;


memberClassDecl: modClass* STRUCT_CLASS IDENTIFIER? classInheritance? LCURLY classBodyDeclStatement RCURLY;
classInheritance: ASSIGN IDENTIFIER (COMMA IDENTIFIER)*;

modAccess: M_PUBLIC | M_PROTECTED | M_PRIVATE | M_INTERNAL;
modFunction: M_INLINE | M_ABSTRACT | M_STATIC | M_VIRTUAL | M_OVERRIDE;
modField: M_STATIC | M_VAR | M_VOLATILE;
modClass: M_VIRTUAL | M_ABSTRACT | M_STATIC | M_FINAL;


/* Flow */
/*
seq: stmt*;
block: LCURLY seq RCURLY;
stmt: block | whileStmt | doWhileStmt | forStmt | returnStmt;
whileStmt: F_WHILE expr stmt;
doWhileStmt: F_DO stmt F_WHILE expr;
forStmt: F_FOR forHeaderStmt stmt;
classBodyDeclStatement: memberDeclStatement | memberConstructorDecl;
memberFieldDecl: typeQualifier? typename IDENTIFIER | typeQualifier? typename ASSIGN expr;
forHeaderStmt:;
returnStmt: F_RETURN expr;
variableDeclarationStmt:
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
unaryAssignments: AR_INCR | AR_DECR | BIT_NOT_NOT | LOG_NOT_NOT;*/