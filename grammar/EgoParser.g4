parser grammar EgoParser;

options {
	tokenVocab = EgoLexer;
}

program: moduleDeclStatement EOF;
seq: stmt*;
stmt:
	blockStmt
	| whileStmt
	| doWhileStmt
	| forStmt
	| returnStmt;
blockStmt: LCURLY seq RCURLY;
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
	typeQualifier? type ID EOS
	| typeQualifier? type assignStmt;
forHeaderStmt:;
returnStmt: F_RETURN expr;
assignStmt: IDENTIFIER ASSIGN expr;
expr:;
memberClassDecl:
	M_CLASS_MODIFIER* CLASS IDENTIFIER? LCURLY classBodyDeclStatement RCURLY;