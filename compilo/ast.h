
#ifndef PROJET_INFO_AST_H
#define PROJET_INFO_AST_H

#include "symbol_table.h"

#define FWRITE(s) {char __str[MAX_SIZE_STR+1];sprintf(__str, "%s\n", s);fwrite(__str,sizeof(char), strlen(__str),f);}
#define MAX_FUNCTION_ARGS 4

typedef enum {
    AST_NODE_EXPRESSION,
    AST_NODE_VARIABLE_DEFINITION,
    AST_NODE_VARIABLE_DECLARATION,
    AST_NODE_VALUE,
    AST_NODE_IF,
    AST_NODE_OPERATOR,
    AST_NODE_SYMBOL,
    AST_NODE_WHILE,
    AST_NODE_FUNCTION_ARGS,
    AST_NODE_RETURN,
    AST_NODE_FUNCTION,
    AST_NODE_FUNCTION_CALL
} ast_node_type;

enum {
    OP_ADD,
    OP_SUB,
    OP_MUL,
    OP_DIV,
    OP_LE,
    OP_GE,
    OP_GT,
    OP_NE,
    OP_EQ,
    OP_LT,
    OP_AND,
    OP_OR,
    OP_NOT,
    OP_ASSIGN
} typedef ast_op_type;
//struct ast_node_struct;
//typedef struct ast_node_struct ast_node;
struct ast_node;

struct ast_expr_struct {
    struct ast_node * node;
    struct ast_expr_struct *next;
} typedef ast_node_expression;

struct {
    int value;
} typedef ast_node_value;

struct {
    symbol_table_entry* entry;
} typedef ast_node_symbol; // equivalent to variable declaration

struct ast_node_variable_definition {
    symbol_table_entry* symbol;
    struct ast_node* value;
} typedef ast_node_variable_definition;

struct {
    struct ast_node *cond;
    struct ast_node *then_block;
    struct ast_node *else_block;
} typedef ast_node_if;

struct {
    ast_op_type op;
    struct ast_node* left;
    struct ast_node* right;
} typedef ast_node_operator;

struct {
    struct ast_node* cond;
    struct ast_node* loop;
} typedef ast_node_while;

struct {
    struct ast_node* args[MAX_FUNCTION_ARGS];
    int nb_of_args;
} typedef ast_node_function_args;

struct {
    struct ast_node* name;
    struct ast_node* args;
    struct ast_node* expr;
} typedef ast_node_function;

struct {
    struct ast_node* entry;
    struct ast_node* function_args;
} typedef ast_node_function_call;

struct {
    struct ast_node* value;
} typedef ast_node_return;
struct {
    ast_node_type type;
    union {
        ast_node_symbol symbol; // variable declaration
        ast_node_variable_definition variable_definition;
        ast_node_value value;
        struct ast_expr_struct expression;
        ast_node_if if_block;
        ast_node_operator operator;
        ast_node_while while_block;
        ast_node_function function;
        ast_node_return ret;
        ast_node_function_args function_args;
        ast_node_function_call function_call;
    };
} typedef ast_node;

struct {
    ast_node *root;
} typedef ast_root;



ast_root* ast_new();
void ast_insert(ast_root*, ast_node*);
ast_node* new_ast_node_value(int value);
ast_node* new_ast_node_symbol(symbol_table_entry* entry);
ast_node* new_ast_node_variable_definition(symbol_table_entry* entry, ast_node* value);
ast_node* new_ast_node_variable_declaration(symbol_table_entry* entry);
ast_node* new_ast_node_expression(ast_node* first, ast_node *second);
ast_node* new_ast_node_if(ast_node* cond, ast_node* then_block, ast_node* else_block);
ast_node* new_ast_node_operator(ast_op_type op, ast_node* left, ast_node* right);
ast_node* new_ast_node_while(ast_node* cond, ast_node* loop);
ast_node* new_ast_node_function(ast_node* name, ast_node* args, ast_node* expr);
ast_node* new_ast_node_function_args(ast_node* args[MAX_FUNCTION_ARGS]);
ast_node* new_ast_node_return(ast_node* ret);
ast_node* new_ast_node_function_call(ast_node* entry, ast_node* function_args);

void ast_to_asm(ast_root* root, FILE*);
void ast_print(ast_root* root);
#endif //PROJET_INFO_AST_H
