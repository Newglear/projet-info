#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ast.h"
#include "mem_manager.h"

#define FWRITE(s) sprintf(str, "%s\n", s);fwrite(str,sizeof(char), strlen(str),f);

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
        case OP_ASSIGN:
            strcpy(op_str, "OP_ASSIGN");
            break;
    }
    return op_str;
}

void write_str(FILE* f, char* str) {
    fprintf(f, "%s", str);
}

reg_t ast_node_to_asm(ast_node* node, FILE* f) {
    static int scope;
    static int temp_var_cnt;
    reg_t r_ret = R_NONE;
    char str[MAX_SIZE_STR] = "";
    if (node == NULL) {
        printf("passed null root %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    reg_t r = 0;

    switch (node->type) {
        case AST_NODE_EXPRESSION:
            ast_node_to_asm((ast_node *) node->expression.node, f);
            if (node->expression.next != NULL)
                ast_node_to_asm((ast_node *) node->expression.next, f);
            break;
        case AST_NODE_VARIABLE_DEFINITION:
            r = get_reg(node->variable_definition.symbol);
            node->variable_definition.symbol->scope = scope;
            printf("reg %d\n", r);
            ast_node *var_node = (ast_node *) node->variable_definition.value;
            reg_t ret_reg_value = ast_node_to_asm(var_node, f);
            if (ret_reg_value == R_NONE) {
                printf("didnt get a register %s\n", __PRETTY_FUNCTION__ );
                exit(-1);
            }
            sprintf(str, "MOV r%d r%d;", r, ret_reg_value);
            FWRITE(str);
            free_reg(ret_reg_value);
            return r;
            break;
        case AST_NODE_VARIABLE_DECLARATION:
            get_reg(node->variable_definition.symbol);
            break;
        case AST_NODE_VALUE:
            sprintf(str, "tmp%d", temp_var_cnt++);
            r = get_reg(symbol_table_entry_init(str, 1, INT, 0, scope));
            sprintf(str, "AFC r%d %d;", r, node->value.value);
            FWRITE(str);
            return r;
            break;
        case AST_NODE_IF:
            FWRITE("# IF COND");
            ast_node_to_asm((ast_node *) node->if_block.cond, f);
            scope++;
            sprintf(str,"JMPNE ENDIF_%d", scope);
            FWRITE(str);
            ast_node_to_asm((ast_node *) node->if_block.then_block, f);
            if (node->if_block.else_block != NULL) {
                sprintf(str,"JMP ENDELSE_%d", scope);
                FWRITE(str);
                sprintf(str,": ENDIF_%d", scope);
                FWRITE(str);
                FWRITE("expr_else");
                ast_node_to_asm((ast_node *) node->if_block.else_block, f);
                sprintf(str,": ENDELSE_%d", scope);
                FWRITE(str);
            } else {
                sprintf(str,": ENDIF_%d", scope);
                FWRITE(str);
            }
            free_regs(scope);
            scope--;
            break;
        case AST_NODE_OPERATOR:
            sprintf(str, "tmp%d", temp_var_cnt++);
            r = get_reg(symbol_table_entry_init(str, 1, INT, 0, scope));
            sprintf(str,"%s r%d r%d r%d;",
                    print_ast_op_type(node->operator.op),
                    r,
                    ast_node_to_asm((ast_node *) node->operator.left, f),
                    node->operator.right == NULL
                        ? R_NONE
                        : ast_node_to_asm((ast_node *) node->operator.right, f)
                    );
            FWRITE(str);
            return r;
        case AST_NODE_SYMBOL:
            return find_reg(node->symbol.entry);
        case AST_NODE_WHILE:
            FWRITE("# WHILE COND");
            sprintf(str, ": WHILE_LOOP_%d", scope);
            FWRITE(str);
            ast_node_to_asm((ast_node *) node->while_block.cond, f);
            sprintf(str, "JMPNE WHILE_END_%d", scope);
            FWRITE(str);

            ast_node_to_asm((ast_node *) node->while_block.loop, f);
            sprintf(str, "JMP WHILE_LOOP_%d", scope);
            FWRITE(str);
            sprintf(str, ": WHILE_END_%d", scope);
            FWRITE(str);
            break;
    }
    return r_ret;
}

void ast_to_asm(ast_root* root, FILE* f) {
    if (root == NULL) {
        printf("passed null root %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    ast_node_to_asm(root->root, f);
}


void ast_node_print(ast_node *node, int tabs) {
    if(node == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    char tab[MAX_SIZE_STR] = "";
    for (int i = 0; i < tabs; i++) {
        strcat(tab,"  ");
        strcat(tab,"  ");
    }
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
            printf("%s AST_NODE_EXPRESSION: \n",tab);
            ast_node_print(node->expression.node, tabs+1);
            if (node->expression.next != NULL)
                ast_node_print(node->expression.next, tabs+1);
            break;
        case AST_NODE_IF:
            printf("%s AST_NODE_IF: \n",tab);
            ast_node_print(node->if_block.cond, tabs+1);
            ast_node_print(node->if_block.then_block, tabs+1);
            if (node->if_block.else_block != NULL)
                ast_node_print(node->if_block.else_block, tabs+1);
            break;
        case AST_NODE_OPERATOR:
            printf("%s AST_NODE_OPERATOR: %s\n",tab, print_ast_op_type(node->operator.op));
            ast_node_print(node->operator.left, tabs+1);
            if(node->operator.right != NULL)
                ast_node_print(node->operator.right, tabs+1);
            break;
        case AST_NODE_SYMBOL:
            printf("%s AST_NODE_SYMBOL: %s\n",tab, node->symbol.entry->symbol);
            break;
        case AST_NODE_WHILE:
            printf("%s AST_NODE_WHILE: \n",tab);
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
