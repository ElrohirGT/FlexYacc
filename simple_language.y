%{
#include <iostream>
#include <string>
#include <map>
static std::map<std::string, int> vars;
static int yylineno = 1;
inline void yyerror(const char *str) {
	fprintf(stderr, "line %d: %s\n", yylineno, str);
}
int yylex();
%}

%union { int num; std::string *str; }

%token<num> NUMBER
%token<str> ID
%type<num> expression
%type<num> innerExpression
%type<num> assignment

%right '='
%left '+' '-'
%left '*' '/'

%%

program: statement_list
        ;

statement_list: statement
    | statement_list statement
    ;

statement: assignment '\n'	{ yylineno += 1; }
    | expression ':' '\n'   { yylineno += 1; std::cout << $1 << std::endl; }
		| '\n' { yylineno +=1; }
    ;

assignment: ID '=' expression
    { 
        printf("Assign %s = %d\n", $1->c_str(), $3); 
        $$ = vars[*$1] = $3; 
        delete $1;
    }
    ;

expression: NUMBER                  { $$ = $1; }
    | ID                            { $$ = vars[*$1];      delete $1; }
		| innerExpression								{}
		| expression '+' expression			{ $$ = $1 + $3; }
		| expression '-' expression			{ $$ = $1 - $3; }
    ;

innerExpression: expression '*' expression     { $$ = $1 * $3; }
    | expression '/' expression     { $$ = $1 / $3; }
    ;




%%

int main() {
    yyparse();
    return 0;
}
