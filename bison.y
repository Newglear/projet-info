%{
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include "symbol_table.h"
#define INT_SIZE 4
int yylex (void);
void yyerror (const char *);


%}


%code 
{
	symbol_table* symbolTable ;
	int scope;
	int offset;
}

%union {char id[32];int val;}         /* Yacc definitions */

/*first element to parse*/
%start start

/* keywords */
%token tVOID
%token tINT
%token tIF
%token tPRINT
%token tELSE
%token tWHILE
%token tRETURN

/* Comparator */
%token tEQ
%token tLE
%token tGE
%token tNE
%token tGT
%token tLT
%token tAND
%token tOR
%token tNOT

/*operators*/
%token tASSIGN
%token tADD
%token tSUB
%token tMUL
%token tDIV

/*syntax*/
%token tLPAR
%token tRPAR
%token tLBRACE
%token tRBRACE
%token tSEMI
%token tCOMMA  
%token <id> tID
%token tNB

%token tERROR

%type <id> variable_assignement
/*conflit shift reduce*/
%left tADD tSUB tMUL tDIV tLT tLE tEQ tNE tGE tGT tAND tOR tNOT
%left tCOMMA

%%
start: expression {symbol_table_print(symbolTable);printf("SUCCESS !\n");}
	;

final_expression : variable_definition 
           | variable_assignement
           | print_statement 
           | if_statement
           | while_statement 
		   | function_call
		   | return_expr
		   | function_definition
	;

expression : variable_definition 
           | variable_assignement  
           | print_statement
           | if_statement
           | while_statement 
		   | function_call
		   | function_definition
		   | final_expression expression
		   | return_expr
	;

function_argument_definition: %empty
							| tINT tID {symbol_table_entry* e = symbol_table_entry_init($2,1,INT,offset,scope);symbol_table_push(symbolTable,e);offset += INT_SIZE;} 
							| tVOID
							| function_argument_definition tCOMMA function_argument_definition
    ;

// TODO: function definition without expression
function_definition : tINT tID  tLPAR {scope++;} function_argument_definition tRPAR tLBRACE expression tRBRACE {pop_scope(&scope,&offset,symbolTable);}
					| tVOID tID tLPAR {scope++;} function_argument_definition tRPAR tLBRACE expression tRBRACE {pop_scope(&scope,&offset,symbolTable);}
    ;

function_args: %empty
		    | value tCOMMA function_args //{printf("multiple value\n");}
    ;

function_call : function_call_void
			  | function_call_int
    ;

function_call_void : tID tLPAR function_args tRPAR tSEMI
function_call_int : tID tLPAR function_args tRPAR

return_expr : tRETURN value tSEMI
    ;

variable_definition: tINT variable_definition_content tSEMI //{printf("def de variable \n");}
    ;                 

variable_definition_content : tID tASSIGN value {symbol_table_entry* e = symbol_table_entry_init($1,1,INT,offset,scope);symbol_table_push(symbolTable,e);offset += INT_SIZE;}
							//| variable_definition_content tCOMMA variable_definition_content 
							| tID {symbol_table_entry* e = symbol_table_entry_init($1,0,INT,offset,scope);symbol_table_push(symbolTable,e);offset += INT_SIZE;}
				   
variable_assignement: tID tASSIGN value tSEMI {symbol_table_entry* e = symbol_table_get_by_symbol($1,symbolTable);e->is_initialised = 1;}
    ;

print_statement : tPRINT tLPAR tRPAR tSEMI 
				| tPRINT tLPAR value tRPAR tSEMI
				;

symbol: tADD
	| tSUB	
	| tMUL
	| tDIV
	| tLE
	| tGE
	| tGT
	| tNE
	| tEQ
	| tLT
	| tAND
	| tOR
	;



final_value: tNB //{printf("num\n");}
      | function_call_int
	  | tNOT final_value	
	  | tID //{printf("ID \n");}
    ;

// Value that can be assign to a variable or in function arguments
value : tNB //{printf("num\n");}
      | function_call_int
	  | final_value symbol value
	  | tNOT value	
	  | tID //{printf("ID \n");}
    ;

if_statement : tIF tLPAR value tRPAR tLBRACE {scope++;} expression tRBRACE {pop_scope(&scope,&offset,symbolTable);}
			 | tIF tLPAR value tRPAR tLBRACE {scope++;} expression tRBRACE {pop_scope(&scope,&offset,symbolTable);} tELSE tLBRACE {scope++;} expression tRBRACE {pop_scope(&scope,&offset,symbolTable);}
			 | tIF tLPAR value tRPAR tLBRACE {scope++;} expression tRBRACE {pop_scope(&scope,&offset,symbolTable);} tELSE if_statement
    ;
                
while_statement : tWHILE tLPAR value tRPAR tLBRACE {scope++;} expression tRBRACE {pop_scope(&scope,&offset,symbolTable);}
    ;

%%                     /* C code */


void yyerror (const char *s) {
	fprintf (stderr, "%s\n", s);
	exit(1);
}

int main (void) {
	printf("Début du bison\n");
	symbolTable = symbol_table_init();
	scope = 0;
	offset = 0;
	yyparse();
}


