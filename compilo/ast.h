
#ifndef PROJET_INFO_AST_H
#define PROJET_INFO_AST_H

#include "symbol_table.h"

enum {
    AST_NODE_EXPRESSION,
    AST_NODE_VARIABLE_DEFINITION,
    AST_NODE_VARIABLE_DECLARATION,
    AST_NODE_VALUE,
} typedef ast_node_type;

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
    ast_node_value* value;
} typedef ast_node_variable_definition;

struct {
    ast_node_type type;
    union {
        ast_node_symbol symbol; // variable declaration
        ast_node_variable_definition variable_definition;
        ast_node_value value;
        struct ast_expr_struct expression;
    };
} typedef ast_node;

struct {
    ast_node *root;
} typedef ast_root;

ast_root* ast_new();
void ast_insert(ast_root*, ast_node*);
ast_node* new_ast_node_value(int value);
ast_node* new_ast_node_symbol(symbol_table_entry* entry, symbol_table* symbol_table);
ast_node* new_ast_node_variable_definition(symbol_table_entry* entry, ast_node* value);
ast_node* new_ast_node_expression(ast_node* first, ast_node *second);


void ast_print(ast_root* root);
#endif //PROJET_INFO_AST_H
