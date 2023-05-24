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
        printf("Root already exists\n");
    }
}

ast_node *new_ast_node_value(int value) {
    printf("newASTNode: %d\n", value);
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
    ast_node* node = malloc(sizeof(ast_node));
    node->type = AST_NODE_VARIABLE_DEFINITION;
    node->variable_definition.symbol = entry;
    node->variable_definition.value = &value->value;
//    printf("created var def node sym: %s, val: %d\n", node->variable_definition.symbol->symbol, node->variable_definition.value->value);
    symbol_entry_print(entry);
    return node;
}
ast_node* new_ast_node_variable_declaration(symbol_table_entry* entry) {
    if (entry == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    ast_node* node = malloc(sizeof(ast_node));
    node->type = AST_NODE_VARIABLE_DECLARATION;
    node->symbol.entry = entry;
    return node;
}
ast_node* new_ast_node_expression(ast_node* first, ast_node* second) {
    if (first == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    ast_node* node = malloc(sizeof(ast_node));
    node->type = AST_NODE_EXPRESSION;
    node->expression.node = first;
    node->expression.next = second;
    return node;
}

void ast_node_print(ast_node *node, int tabs) {
    if(node == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    char tab[tabs*2 +1];
    tab[0] = '\0';
    for (int i = 0; i < tabs; i += 2) {
        tab[i] = ' ';
        tab[i+1] = ' ';
    }
    tab[tabs*2 +1] = '\0';
    printf("%s{\n", tab);
    switch (node->type) {

        case AST_NODE_VARIABLE_DEFINITION:
            printf("%s AST_NODE_VARIABLE_DEFINITION: {\n", tab);
            printf("%s   smbol: %s\n",tab, node->variable_definition.symbol->symbol);
            printf("%s   value: %d\n",tab, node->variable_definition.value->value);
            printf("%s }\n",tab);
            break;
        case AST_NODE_VARIABLE_DECLARATION:
            printf("%s AST_NODE_VARIABLE_DECLARATION: {\n",tab);
            printf("%s symbol: %s\n",tab, node->symbol.entry->symbol);
            printf("%s }\n",tab);
            break;
        case AST_NODE_VALUE:
            printf("%s AST_NODE_VALUE: %d\n",tab, node->value.value);
            break;
        case AST_NODE_EXPRESSION:
            printf("%s AST_NODE_EXPRESSION: ",tab);
            ast_node_print(node->expression.node, tabs+1);
            if (node->expression.next != NULL)
                ast_node_print(node->expression.next, tabs+1);
            break;
    }
    printf("%s}\n", tab);

}

void ast_print(ast_root* root) {
    ast_node_print(root->root,0);
}
