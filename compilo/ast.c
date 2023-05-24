#include <stdlib.h>
#include <stdio.h>
#include "ast.h"

ast_root *ast_new() {
    ast_root *root = malloc(sizeof(ast_root));
    root->root = NULL;
    return root;
}

void ast_insert(ast_root *root, ast_node *node) {
    if (root->root == NULL) {
        root->root = node;
    } else {
        printf("Root already exists");
    }
}

ast_node *new_ast_node_value(int value) {
    ast_node *node = malloc(sizeof(ast_node));
    node->type = AST_NODE_VALUE;
    node->value.value = value;
    return node;
}

ast_node *new_ast_node_symbol(symbol_table_entry *entry, symbol_table *symbol_table) {
    ast_node *node = malloc(sizeof(ast_node));
    //symbol_table_push(symbol_table, entry);
    node->type = AST_NODE_VARIABLE_DECLARATION;
    node->symbol.entry = entry;
    return node;
}

ast_node* new_ast_node_variable_definition(symbol_table_entry *entry, ast_node* value) {
    if(value->type != AST_NODE_VALUE) {
        printf("value is not ast_node_value %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    ast_node *node = malloc(sizeof(ast_node));
    node->type = AST_NODE_VARIABLE_DEFINITION;
    node->variable_definition.symbol = entry;
    node->variable_definition.value = value; // TODO save the value inside the struc correctry, rvably deref and copy
    printf("created var def node\n");
    symbol_entry_print(entry);
    return node;
}

ast_node* new_ast_node_expression(ast_node* first, ast_node* second) {
    return NULL;
}

void ast_node_print(ast_node *node) {
    printf("{dw\n");
    if(node == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    printf("%d\n", node->type);
    switch (node->type) {

        case AST_NODE_VARIABLE_DEFINITION:
            printf("AST_NODE_VARIABLE_DEFINITION: {\n");
            printf("smbol: %s\n", node->variable_definition.symbol->symbol);
            printf("value: %d\n", node->variable_definition.value->value);
            printf("}\n");
            break;
        case AST_NODE_VARIABLE_DECLARATION:
            printf("AST_NODE_VARIABLE_DECLARATION: {\n");
            printf("symbol: %s\n", node->symbol.entry->symbol);
            printf("}\n");
            break;
        case AST_NODE_VALUE:
            printf("AST_NODE_VALUE: %d\n", node->value.value);
            break;
    }
}

void ast_print(ast_root* root) {
    ast_node_print(root->root);
}
