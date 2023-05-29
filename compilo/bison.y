%{
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <string.h>
#include "symbol_table.h"
#include "ast.h"

int yylex (void);
void yyerror (const char *);


%}

%code requires {
  #include "ast.h"
}

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
	ast_node* node;
	ast_node_type opearnd;
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

%type <opearnd> symbol
%type <node> final_value
%type <node> value
%type <node> expression
%type <node> variable_definition_content
%type <node> variable_definition
%type <node> final_expression
%type <node> if_statement
%type <node> if_cont
%type <node> while_statement

/*conflit shift reduce*/
%left tADD tSUB tMUL tDIV tLT tLE tEQ tNE tGE tGT tAND tOR tNOT 
%left tCOMMA
%right tELSE

%%
start: expression {
	ast_node* node = (ast_node*) new_ast_node_expression($1, NULL);
	ast_insert(root, node);
	symbol_table_print(symbolTable);
	symbol_table_print(functionTable);
	symbol_table_print(functionTable);
	printf("SUCCESS !\n");
	ast_insert(root, $1);
	}
	;

final_expression : variable_definition
//           | variable_assignement
//           | print_statement
           | if_statement
           | while_statement
           | value tSEMI
//	   | function_call
//	   | return_expr
//	   | function_definition
	;

expression : final_expression
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
//		| tINT tID { push_element(symbolTable,$2,1,INT,&offset,scope);}
//		| tVOID
//	;
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
//function_call_void : tID  tLPAR function_args tRPAR tSEMI {write_assembly_single("JMP",$1,out_file);pop_scope(&scope,&offset,symbolTable);}
//function_call_int : tID tLPAR function_args tRPAR {write_assembly_single("JMP",$1,out_file);}
//
//return_expr : tRETURN value tSEMI
//    ;

variable_definition: tINT variable_definition_content tSEMI {
		$$ = $2;
	}
    ;                 

variable_definition_content : tID tASSIGN value {
	symbol_table_entry* e = push_element(symbolTable,$1,1,INT,&offset,scope);
	$$ = new_ast_node_variable_definition(e, $3);
	} // Copy the value from a to b
	| tID {
	symbol_table_entry* e = push_element(symbolTable,$1,1,INT,&offset,scope);
	ast_node* value = new_ast_node_value(0);
	$$ = new_ast_node_variable_definition(e, value);
	}


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
	| tASSIGN { $$ = OP_ASSIGN;}
	;



final_value: tNB {
		$$ = new_ast_node_value($1);
	}
	| tNOT final_value {
		$$ = new_ast_node_operator(OP_NOT, $2, NULL);
	}
	| tID  {
		symbol_table_entry* e = symbol_table_get_by_symbol($1,symbolTable);
		$$ = new_ast_node_symbol(e);
	}
    ;

// Value that can be assign to a variable or in function arguments
value : final_value
	| final_value symbol value {
		$$ = new_ast_node_operator($2, $1, $3); // TODO
	}
;

if_statement : tIF tLPAR value tRPAR tLBRACE expression tRBRACE if_cont {
		ast_node* value = new_ast_node_if($3, $6, $8);
		$$ = value;
	}
    ;

if_cont : %empty {
		$$ = NULL;
	}
	| tELSE tLBRACE expression tRBRACE {
		$$ = $3;
	}
    ;

while_statement : tWHILE tLPAR value tRPAR tLBRACE  expression tRBRACE {
	$$ = (ast_node*) new_ast_node_while($3,$6);
	}
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
	ast_to_asm(root, symbolTable, out_file);
	symbol_table_print(symbolTable);
	fclose(out_file);

}


