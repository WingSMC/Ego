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
moduleDeclStatement:
	memberDeclStatement
	| moduleImportDecl
	| moduleExportDecl;
classBodyDeclStatement:
	memberDeclStatement
	| memberConstructorDecl;
memberFieldDecl:
	typeQualifier? typename IDENTIFIER EOS
	| typeQualifier? typename ASSIGN stmt;
forHeaderStmt:;
returnStmt: F_RETURN expr;
assignStmt: IDENTIFIER ASSIGN expr;
expr:;
memberClassDecl:
	m_class* CLASS IDENTIFIER? classInheritance? LCURLY classBodyDeclStatement RCURLY;

classInheritance: ASSIGN IDENTIFIER (S_COMMA IDENTIFIER)*;
assignments:
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
unary_assignments:
	AR_INCR
	| AR_DECR
	| BIT_NOT_NOT
	| LOG_NOT_NOT;
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
	| T_AUTO
	| T_VOID;

m_access: M_PUBLIC | M_PROTECTED | M_PRIVATE | M_INTERNAL;
m_function:
	M_INLINE
	| M_ABSTRACT
	| M_STATIC
	| M_VIRTUAL
	| M_OVERRIDE;
m_field: M_STATIC | M_MUT | M_VOLATILE;
m_class: M_VIRTUAL | M_ABSTRACT | M_STATIC;

// TODO & operator addr & or

// TODO ARRAY_ACCESS 