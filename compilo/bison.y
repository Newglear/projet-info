%{
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"
#include "ast.h"

int yylex (void);
void yyerror (const char *);


%}


%code 
{
	FILE* out_file = NULL;
	symbol_table* symbolTable ;
	symbol_table* functionTable;
	symbol_table* flowControlTable;
	int scope;
	int offset;
	int temp_cnt;
	ast_root* root;
}

%union {
	char id[32];
	int val;
	struct ast_node* node;
	ast_op_type opearnd;
}         /* Yacc definitions */

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
%type <opearnd> symbol
%type <node> final_value
%type <node> value
%type <node> expression
%type <node> variable_definition_content
%type <node> variable_definition
%type <node> final_expression
%type <node> if_statement
%type <node> if_cont

/*conflit shift reduce*/
%left tADD tSUB tMUL tDIV tLT tLE tEQ tNE tGE tGT tAND tOR tNOT 
%left tCOMMA
%right tELSE

%%
start: expression {
	ast_node* node = new_ast_node_expression($1, NULL);
	ast_insert(root, node);
	symbol_table_print(symbolTable);
	symbol_table_print(functionTable);
	symbol_table_print(functionTable);
	printf("SUCCESS !\n");
	fclose(out_file);
	ast_insert(root, $1);
	}
	;

final_expression : variable_definition
//           | variable_assignement
//           | print_statement
           | if_statement
//           | while_statement
//	   | function_call
//	   | return_expr
//	   | function_definition
	;

expression : variable_definition
//           | variable_assignement
//           | print_statement
           | if_statement
//           | while_statement
//	   | function_call
//	   | function_definition
	   | final_expression expression {
	   	ast_node* node = new_ast_node_expression($1, $2);
		$$ = node;
	   }
//	   | return_expr
	;

//function_body : variable_definition
//           | variable_assignement
//           | print_statement
//           | if_statement
//           | while_statement
//	   | function_call
//	   | final_expression expression
//	   | return_expr
//	;

//function_argument_definition: %empty
//			| tINT tID { push_element(symbolTable,$2,1,INT,&offset,scope);}
//			| tVOID
//			| function_argument_definition_bis tCOMMA function_argument_definition
//    ;
//function_argument_definition_bis : %empty
								| tINT tID { push_element(symbolTable,$2,1,INT,&offset,scope);}
								| tVOID
	;
//// TODO: function definition without expression
//function_definition : tINT tID  tLPAR {scope++;write_assembly_none($2,out_file);} function_argument_definition tRPAR tLBRACE function_body tRBRACE {pop_scope(&scope,&offset,symbolTable); function_table_push(functionTable,symbol_table_entry_init($2, 1,INT, 0,0));} // Gestion du write asm quand ?
//					| tVOID tID tLPAR {scope++;write_assembly_none($2,out_file);} function_argument_definition tRPAR tLBRACE function_body tRBRACE {pop_scope(&scope,&offset,symbolTable); function_table_push(functionTable,symbol_table_entry_init($2, 1,VOID, 0,0));}
//    ;

//function_args: %empty
//		    | value  tCOMMA function_args
//    ;
//
//function_call : function_call_void
//			  | function_call_int
//    ;
//
//function_call_void : tID {scope++;} tLPAR function_args tRPAR tSEMI {write_assembly_single("JMP",$1,out_file);pop_scope(&scope,&offset,symbolTable);}
//function_call_int : tID tLPAR function_args tRPAR {write_assembly_single("JMP",$1,out_file);}
//
//return_expr : tRETURN value tSEMI
//    ;

variable_definition: tINT variable_definition_content tSEMI {
		$$ = $2;
	}
    ;                 

variable_definition_content : tID tASSIGN value {
//	write_assembly("COP",offset,$3,out_file);
//	symbol_table_pop(symbolTable,&offset);
//	push_element(symbolTable,$1,1,INT,&offset,scope);
	symbol_table_entry* e = symbol_table_entry_init($1, 1, INT, offset, scope);
//	ast_node* value = new_ast_node_value($3);
	$$ = new_ast_node_variable_definition(e, $3);
	} // Copy the value from a to b
	| tID {
//	push_element(symbolTable,$1,0,INT,&offset,scope);
	symbol_table_entry* e = symbol_table_entry_init($1, 0, INT, offset, scope);
	ast_node* value = new_ast_node_value($1);
	$$ = new_ast_node_variable_definition(e, value);
	$$ = new_ast_node_symbol(e, symbolTable);
	}
				   
variable_assignement: tID tASSIGN value tSEMI {
	 symbol_table_entry* e = symbol_table_get_by_symbol($1,symbolTable);
	 e->is_initialised = 1;
	 symbol_table_pop(symbolTable,&offset);
	 push_element(symbolTable,$1,1,INT,&offset,scope);
	 }
    ;

print_statement : tPRINT tLPAR tRPAR tSEMI 
				| tPRINT tLPAR value tRPAR tSEMI
				;

// TODO
symbol: tADD {$$ = OP_ADD;}
	| tSUB	 { $$ = OP_SUB;}
	| tMUL   { $$ = OP_MUL;}
	| tDIV   { $$ = OP_DIV;}
	| tLE	 { $$ = OP_LE;}
	| tGE    { $$ = OP_GE;}
	| tGT	 { $$ = OP_GT;}
	| tNE    { $$ = OP_NE;}
	| tEQ	 { $$ = OP_EQ;}
	| tLT    { $$ = OP_LT;}
	| tAND   { $$ = OP_AND;}
	| tOR	 { $$ = OP_OR;}
	;



final_value: tNB {
		$$ = offset; char str[15]; 
		sprintf(str,"%d",temp_cnt++); 
		strcat(str,"t"); 
		write_assembly("AFC", offset -INT_SIZE , $1, out_file); 
		push_element(symbolTable,str,1,INT, &offset,scope); 
	}
//	| function_call_int
	| tNOT final_value { 
		$$ = new_ast_node_operator(OP_NOT, $2, NULL);
	}
	| tID  {
		char str[15]; 
		sprintf(str,"%d",temp_cnt++); 
		strcat(str,"t"); 
		push_element(symbolTable,str,1,INT, &offset,scope);
		int e_offset = symbol_table_get_by_symbol($1,symbolTable)->offset;
		write_assembly("COP", offset,e_offset,out_file); $$ = offset;
		}
    ;

// Value that can be assign to a variable or in function arguments
value : tNB {
		$$ = new_ast_node_value($1);
	} // AFC
//      | function_call_int
	| final_value symbol value {
		$$ = NULL; // TODO
	}
	| tNOT value {
		$$ = new_ast_node_operator(OP_NOT, $2, NULL);
	}
	| tID {char str[15]; sprintf(str,"%d",temp_cnt++); strcat(str,"t"); push_element(symbolTable,str,1,INT, &offset,scope);int e_offset = symbol_table_get_by_symbol($1,symbolTable)->offset;write_assembly("COP", offset,e_offset,out_file); $$ = offset;}
       ;

if_statement : tIF tLPAR value tRPAR tLBRACE  expression tRBRACE if_cont {
		ast_node* value = new_ast_node_if($3, $6, $8);
		$$ = value;
	}
//	| tIF tLPAR value tRPAR tLBRACE /*{flow_control_push("ELSE",flowControlTable, scope, out_file);scope++;}*/ expression tRBRACE {pop_scope(&scope,&offset,symbolTable);flow_control_pop(flowControlTable,&scope, out_file);} tELSE tLBRACE {scope++;} expression tRBRACE {pop_scope(&scope,&offset,symbolTable);} %prec tELSE
//	| tIF tLPAR value tRPAR tLBRACE /*{flow_control_push("ELSE",flowControlTable, scope, out_file);scope++;}*/ expression tRBRACE {pop_scope(&scope,&offset,symbolTable);flow_control_pop(flowControlTable,&scope, out_file);} tELSE if_statement
    ;

if_cont : %empty {
		$$ = NULL;
	}
	| tELSE tLBRACE expression tRBRACE {
		$$ = $3;
	}
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
	//push_element(symbolTable,"SP",1,INT,0,0);
	//push_element(symbolTable,"LR",1,INT,0,0);
	flowControlTable = symbol_table_init();
	root = ast_new();
	scope = 0;
	offset = 0;
	temp_cnt = 0;
	yyparse();
	ast_print(root);
}


