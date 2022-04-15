parser grammar EgoParser;

options {
	tokenVocab = EgoLexer;
}

program: moduleDeclStatement EOF;
seq: stmt*;
block: LCURLY seq RCURLY;
stmt: block | whileStmt | doWhileStmt | forStmt | returnStmt;
whileStmt: F_WHILE expr stmt;
doWhileStmt: F_DO stmt F_WHILE expr;
forStmt: F_FOR forHeaderStmt stmt;
memberDeclStatement:
	memberFieldDecl
	| memberPropertyDecl
	| memberMethodDecl
	| memberClassDecl
	| memberInterfaceDecl
	| memberEnumDecl;
moduleDeclStatement: memberDeclStatement | moduleImportDecl | moduleExportDecl;
classBodyDeclStatement: memberDeclStatement | memberConstructorDecl;
memberFieldDecl: typeQualifier? typename IDENTIFIER | typeQualifier? typename ASSIGN expr;
forHeaderStmt:;
returnStmt: F_RETURN expr;
assignStmt: IDENTIFIER ASSIGN expr;
expr:;
coalescingExpr: expr NULL_COALESCE <assoc = right> expr;
assignmentExpr: IDENTIFIER opAssignment <assoc = right> expr;

memberClassDecl: mod_class* STRUCT_CLASS IDENTIFIER? classInheritance? LCURLY classBodyDeclStatement RCURLY;

classInheritance: ASSIGN IDENTIFIER (COMMA IDENTIFIER)*;
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
	| T_VOID;

mod_access: M_PUBLIC | M_PROTECTED | M_PRIVATE | M_INTERNAL;
mod_function: M_INLINE | M_ABSTRACT | M_STATIC | M_VIRTUAL | M_OVERRIDE;
mod_field: M_STATIC | M_VAR | M_VOLATILE;
mod_class: M_VIRTUAL | M_ABSTRACT | M_STATIC | M_FINAL;
eos: SEMI | NL | EOF;
