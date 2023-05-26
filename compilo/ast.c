#include <stdlib.h>
#include <stdio.h>
#include "ast.h"
#include <string.h>

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

int isValue(ast_node* node) {
    return node->type == AST_NODE_VALUE
            || node->type == AST_NODE_OPERATOR
            || node->type == AST_NODE_SYMBOL;
}

ast_node *new_ast_node_value(int value) {
    printf("newASTNode: %d\n", value);
    ast_node *node = malloc(sizeof(ast_node));
    node->type = AST_NODE_VALUE;
    node->value.value = value;
    return node;
}

ast_node *new_ast_node_symbol(symbol_table_entry *entry) {
    if (entry == NULL) {
        printf("variable does not exist; %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    ast_node *node = malloc(sizeof(ast_node));
    //symbol_table_push(symbol_table, entry);
    node->type = AST_NODE_SYMBOL;
    node->symbol.entry = entry;
    return node;
}

ast_node* new_ast_node_variable_definition(symbol_table_entry *entry, ast_node* value) {
    if(!isValue(value)) {
        printf("value is not ast_node_value %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    ast_node* node = malloc(sizeof(ast_node));
    node->type = AST_NODE_VARIABLE_DEFINITION;
    node->variable_definition.symbol = entry;
    node->variable_definition.value = (struct ast_node *) value;
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
    node->expression.node = (struct ast_node *) first;
    node->expression.next = (struct ast_expr_struct *) second;
    return node;
}

ast_node* new_ast_node_if(ast_node* cond, ast_node* then_block, ast_node* else_block) {
    if (cond == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    if (then_block == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    ast_node* node = malloc(sizeof(ast_node));
    node->type = AST_NODE_IF;
    node->if_block.cond = (struct ast_node *) cond;
    node->if_block.then_block = (struct ast_node *) then_block;
    node->if_block.else_block = (struct ast_node *) else_block;
    return node;
}

ast_node* new_ast_node_operator(ast_op_type op, ast_node* left, ast_node* right) {
    if(left == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    ast_node* node = malloc(sizeof(ast_node));
    node->type = AST_NODE_OPERATOR;
    node->operator.op = op;
    node->operator.left = (struct ast_node *) left;
    node->operator.right = (struct ast_node *) right;
    if(right == NULL && op != OP_NOT) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    return node;
}

ast_node* new_ast_node_while(ast_node* cond, ast_node* loop) {
    if (cond == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    if (!isValue(cond))  {
        printf("passed non-value node %s\n", __PRETTY_FUNCTION__ );
    }
    ast_node* node = malloc(sizeof(ast_node));
    node->type = AST_NODE_WHILE;
    node->while_block.cond = (struct ast_node *) cond;
    node->while_block.loop = (struct ast_node *) loop;
    return node;
}

char* print_ast_op_type(ast_op_type op) {
    char *op_str = malloc((sizeof(char))*8);
    switch (op) {
        case OP_ADD:
            strcpy(op_str, "OP_ADD");
            break;
        case OP_SUB:
            strcpy(op_str, "OP_SUB");
            break;
        case OP_MUL:
            strcpy(op_str, "OP_MUL");
            break;
        case OP_DIV:
            strcpy(op_str, "OP_DIV");
            break;
        case OP_LE:
            strcpy(op_str, "OP_LE");
            break;
        case OP_GE:
            strcpy(op_str, "OP_GE");
            break;
        case OP_GT:
            strcpy(op_str, "OP_GT");
            break;
        case OP_NE:
            strcpy(op_str, "OP_NE");
            break;
        case OP_EQ:
            strcpy(op_str, "OP_EQ");
            break;
        case OP_LT:
            strcpy(op_str, "OP_LT");
            break;
        case OP_AND:
            strcpy(op_str, "OP_AND");
            break;
        case OP_OR:
            strcpy(op_str, "OP_OR");
            break;
        case OP_NOT:
            strcpy(op_str, "OP_NOT");
            break;
    }
    return op_str;
}

void ast_node_print(ast_node *node, int tabs) {
    if(node == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    char tab[tabs*2 +2];
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
//            printf("%s   value: %d\n",tab, node->variable_definition.value->value);
            if (node->variable_definition.value != NULL)
                ast_node_print(node->variable_definition.value, tabs+1);
            else printf("%s   value: NULL\n",tab);
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
        case AST_NODE_IF:
            printf("%s AST_NODE_IF: ",tab);
            ast_node_print(node->if_block.cond, tabs+1);
            ast_node_print(node->if_block.then_block, tabs+1);
            if (node->if_block.else_block != NULL)
                ast_node_print(node->if_block.else_block, tabs+1);
            break;
        case AST_NODE_OPERATOR:
            printf("%s AST_NODE_OPERATOR: %s",tab, print_ast_op_type(node->operator.op));
            ast_node_print(node->operator.left, tabs+1);
            if(node->operator.right != NULL)
                ast_node_print(node->operator.right, tabs+1);
            break;
        case AST_NODE_SYMBOL:
            printf("%s AST_NODE_SYMBOL: %s",tab, node->symbol.entry->symbol);
            break;
        case AST_NODE_WHILE:
            printf("%s AST_NODE_WHILE: ",tab);
            if (node->while_block.loop != NULL)
                ast_node_print(node->while_block.loop, tabs+1);
            else printf("PASS\n");
            break;
    }
    printf("%s}\n", tab);

}

void ast_print(ast_root* root) {
    ast_node_print(root->root,0);
}
