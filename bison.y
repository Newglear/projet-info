%{
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"
#define INT_SIZE 4
#define MAX_SIZE_STR 420
int yylex (void);
void yyerror (const char *);


%}


%code 
{
	FILE* out_file = NULL;
	symbol_table* symbolTable ;
	symbol_table* functionTable;
	int scope;
	int offset;
	int temp_cnt; 
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
%token <val>tNB

%token tERROR

%type <id> variable_assignement
%type <id> symbol
%type <val> final_value
%type <val> value

/*conflit shift reduce*/
%left tADD tSUB tMUL tDIV tLT tLE tEQ tNE tGE tGT tAND tOR tNOT
%left tCOMMA

%%
start: expression {symbol_table_print(symbolTable);printf("SUCCESS !\n");fclose(out_file);}
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

function_body : variable_definition 
           | variable_assignement  
           | print_statement
           | if_statement
           | while_statement 
		   | function_call
		   | final_expression expression
		   | return_expr
	;

function_argument_definition: %empty
			| tINT tID { push_element(symbolTable,$2,1,INT,&offset,scope);}
			| tVOID
			| function_argument_definition tCOMMA function_argument_definition
    ;

// TODO: function definition without expression
function_definition : tINT tID  tLPAR {scope++;} function_argument_definition tRPAR tLBRACE function_body tRBRACE {pop_scope(&scope,&offset,symbolTable);}
					| tVOID tID tLPAR {scope++;} function_argument_definition tRPAR tLBRACE function_body tRBRACE {pop_scope(&scope,&offset,symbolTable);}
    ;

function_args: %empty
		    | value tCOMMA function_args
    ;

function_call : function_call_void
			  | function_call_int
    ;

function_call_void : tID tLPAR function_args tRPAR tSEMI
function_call_int : tID tLPAR function_args tRPAR

return_expr : tRETURN value tSEMI
    ;

variable_definition: tINT variable_definition_content tSEMI 
    ;                 

variable_definition_content : tID tASSIGN value {char str[MAX_SIZE_STR] = "COP ";char addr[MAX_SIZE_STR]; sprintf(addr," %d ",offset); strcat(str,addr); sprintf(addr," %d;\n",$3); strcat(str,addr);fwrite(str,sizeof(char),strlen(str),out_file);push_element(symbolTable,$1,1,INT,&offset,scope);} // Copy the value from a to b 
							| tID { push_element(symbolTable,$1,0,INT,&offset,scope);}
				   
variable_assignement: tID tASSIGN value tSEMI {symbol_table_entry* e = symbol_table_get_by_symbol($1,symbolTable);e->is_initialised = 1;}
    ;

print_statement : tPRINT tLPAR tRPAR tSEMI 
				| tPRINT tLPAR value tRPAR tSEMI
				;

symbol: tADD //{$$ = "ADD";}
	| tSUB	 //{$$ = "SUB";}
	| tMUL   //{$$ = "MUL";}
	| tDIV   //{$$ = "DIV";}
	| tLE
	| tGE
	| tGT
	| tNE
	| tEQ
	| tLT
	| tAND
	| tOR
	;



final_value: tNB { $$ = offset; char str[15]; sprintf(str,"%d",temp_cnt++); strcat(str,"t"); push_element(symbolTable,str,1,INT, &offset,scope); }
      | function_call_int 
	  | tNOT final_value { $$ = offset; char str[15]; sprintf(str,"%d",temp_cnt++); strcat(str,"t"); push_element(symbolTable,str,1,INT, &offset,scope); }
	  | tID  {$$ = symbol_table_get_by_symbol($1,symbolTable)->offset ; }
    ;

// Value that can be assign to a variable or in function arguments
value : tNB {  $$ = offset; char str[15]; sprintf(str,"%d",temp_cnt++); strcat(str,"t"); push_element(symbolTable,str,1,INT, &offset,scope);} // AFC
      | function_call_int
	  | final_value symbol value {printf("OP(%d %s %d) \n",$1,$2,$3);}
	  | tNOT value	{ $$ = offset; char str[15]; sprintf(str,"%d",temp_cnt++); strcat(str,"t"); push_element(symbolTable,str,1,INT, &offset,scope);}
	  | tID {$$ = symbol_table_get_by_symbol($1,symbolTable)->offset ; }
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

int main (int argc, char* argv[] ) {
	if(argc<2){
		printf("Not enough output files \n");
		exit(-1);
	}

	out_file = fopen(argv[1],"w");

	symbolTable = symbol_table_init();
	functionTable = symbol_table_init();
	scope = 0;
	offset = 0;
	temp_cnt = 0;
	yyparse();
}


