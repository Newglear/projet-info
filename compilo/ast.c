#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "ast.h"
#include "mem_manager.h"

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

ast_node* new_ast_node_function(ast_node* name, ast_node* args, ast_node* expr) {
    if (args == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    ast_node* node = malloc(sizeof(ast_node));
    node->type = AST_NODE_FUNCTION;
    node->function.name = (struct ast_node *) name;
    node->function.args = (struct ast_node *) args;
    node->function.expr = (struct ast_node *) expr;
    return node;
}

ast_node* new_ast_node_function_args(ast_node* args[MAX_FUNCTION_ARGS]) {
    if (args == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    int nb_args = 0;
    ast_node* node = malloc(sizeof(ast_node));
    node->type = AST_NODE_FUNCTION_ARGS;
    for (int i = 0; i < MAX_FUNCTION_ARGS; i++) {
        node->function_args.args[i] = (struct ast_node *) args[i];
        if (args[i] != NULL) {
            nb_args++;
        }
    }
    node->function_args.nb_of_args = nb_args;
    return node;
}

ast_node* new_ast_node_return(ast_node* ret) {
    if (ret == NULL) {
        printf("passed null node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    ast_node* node = malloc(sizeof(ast_node));
    node->type = AST_NODE_RETURN;
    node->ret.value = (struct ast_node *) ret;
    return node;
}

ast_node* new_ast_node_function_call(ast_node* entry, ast_node* function_args) {
    if (entry == NULL) {
        printf("passed null node entry %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    if (function_args == NULL) {
        printf("passed null node args %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    if (function_args->type != AST_NODE_FUNCTION_ARGS) {
        printf("passed non-function node %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    ast_node* node = malloc(sizeof(ast_node));
    node->type = AST_NODE_FUNCTION_CALL;
    node->function_call.entry = (struct ast_node *) entry;
    node->function_call.function_args = (struct ast_node *) function_args;
    return node;

}

char* print_ast_op_type(ast_op_type op) {
    char *op_str = malloc((sizeof(char))*MAX_SIZE_STR);
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

struct {
    FILE* file;
    symbol_table* symbol_table;
} typedef compiler_args;

enum tree_position {
    RIGHT,
    LEFT
};

void replace_value(ast_node* node, ast_node* new_value, enum tree_position pos) {
    switch (node->type) {
        case AST_NODE_EXPRESSION:
            break;
        case AST_NODE_VARIABLE_DEFINITION:
            node->variable_definition.value = (struct ast_node *) new_value;
            break;
        case AST_NODE_VARIABLE_DECLARATION:
            break;
        case AST_NODE_VALUE:
            break;
        case AST_NODE_IF:
            node->if_block.cond = (struct ast_node *) new_value;
            break;
        case AST_NODE_OPERATOR:
            switch (pos) {
                case RIGHT:
                    node->operator.right = (struct ast_node *) new_value;
                    break;
                case LEFT:
                    node->operator.left = (struct ast_node *) new_value;
                    break;
            }
            break;
        case AST_NODE_SYMBOL:
            break;
        case AST_NODE_WHILE:
            node->while_block.cond = (struct ast_node *) new_value;
            break;
        case AST_NODE_FUNCTION_ARGS:
            break;
        case AST_NODE_RETURN:
            node->ret.value = (struct ast_node *) new_value;
            break;
        case AST_NODE_FUNCTION:
            break;
        case AST_NODE_FUNCTION_CALL:
            break;
    }
}

int ast_node_opti(ast_node* node, ast_node* parent) {
    int ret = 0;
    ast_node* temp_node = NULL;
    int temp1 = 0;
    int temp2 = 0;
    switch (node->type) {
        case AST_NODE_EXPRESSION:
            ret = ast_node_opti((ast_node *) node->expression.node, node);
            if (node->expression.next) {
                ret += ast_node_opti((ast_node *) node->expression.next, node);
            }
            return ret;
        case AST_NODE_VARIABLE_DEFINITION:
            return ast_node_opti((ast_node *) node->variable_definition.value, node);
            break;
        case AST_NODE_VARIABLE_DECLARATION:
            break;
        case AST_NODE_VALUE:
            break;
        case AST_NODE_IF:
            break;
        case AST_NODE_OPERATOR:
            if(node->operator.op != OP_NOT) {
                if (((ast_node*)node->operator.right)->type != AST_NODE_VALUE) {
                    ret += ast_node_opti((ast_node *) node->operator.right, node);
                }
                temp1 = ((ast_node*)node->operator.right)->value.value;
                temp2 = ((ast_node*)node->operator.left)->value.value;
                switch (node->operator.op) {
                    case OP_ADD:
                        temp_node = new_ast_node_value(temp1 + temp2);
                        replace_value(parent, temp_node, RIGHT);
                        return 1;
                        break;
                    case OP_SUB:
                        break;
                    case OP_MUL:
                        break;
                    case OP_DIV:
                        break;
                    case OP_LE:
                        break;
                    case OP_GE:
                        break;
                    case OP_GT:
                        break;
                    case OP_NE:
                        break;
                    case OP_EQ:
                        break;
                    case OP_LT:
                        break;
                    case OP_AND:
                        break;
                    case OP_OR:
                        break;
                    case OP_NOT:
                        break;
                    case OP_ASSIGN:
                        break;
                }
            }
            break;
        case AST_NODE_SYMBOL:
            break;
        case AST_NODE_WHILE:
            break;
        case AST_NODE_FUNCTION_ARGS:
            break;
        case AST_NODE_RETURN:
            break;
        case AST_NODE_FUNCTION:
            break;
        case AST_NODE_FUNCTION_CALL:
            break;
    }
    return 0;
}

int ast_opti(ast_root* root) {
    if(root == NULL) {
        printf("passed NULL %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    return ast_node_opti(root->root, NULL);
}


reg_t ast_node_to_asm(ast_node* node, compiler_args* args) {
    static int scope;
    static int temp_var_cnt;
    FILE* f = args->file;
    reg_t r_ret = R_NONE;
    reg_t r = 0;
    char str[MAX_SIZE_STR] = "";
    if (node == NULL) {
        printf("passed null root %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }

    switch (node->type) {
        case AST_NODE_EXPRESSION:
            ast_node_to_asm((ast_node *) node->expression.node, args);
            if (node->expression.next != NULL)
                ast_node_to_asm((ast_node *) node->expression.next, args);
            break;
        case AST_NODE_VARIABLE_DEFINITION:
            r = var_store(node->variable_definition.symbol,&scope,f);
//            node->variable_definition.symbol->scope = scope;
            printf("reg %d\n", r);
            ast_node *var_node = (ast_node *) node->variable_definition.value;
            reg_t ret_reg_value = ast_node_to_asm(var_node, args);
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
            var_store(node->variable_definition.symbol,&scope,f);
            break;
        case AST_NODE_VALUE:
            sprintf(str, "tmp%d", temp_var_cnt++);
            r = var_store(
                    symbol_table_entry_init(str, 1, INT, 0, scope),
                    &scope,
                    f);
            sprintf(str, "AFC r%d %d;", r, node->value.value);
            FWRITE(str);
            return r;
            break;
        case AST_NODE_IF:
            FWRITE("# IF COND");
            ast_node_to_asm((ast_node *) node->if_block.cond, args);
            open_scope(&scope);
            sprintf(str,"JMPNE __ENDIF_%d__", scope);
            FWRITE(str);
            ast_node_to_asm((ast_node *) node->if_block.then_block, args);
            if (node->if_block.else_block != NULL) {
                sprintf(str,"JMP __ENDELSE_%d__", scope);
                FWRITE(str);
                sprintf(str,"__ENDIF_%d__", scope);
                FWRITE(str);
                ast_node_to_asm((ast_node *) node->if_block.else_block, args);
                sprintf(str,"__ENDELSE_%d__", scope);
                FWRITE(str);
            } else {
                sprintf(str,"__ENDIF_%d__", scope);
                FWRITE(str);
            }
            close_scope(&scope, f);
            break;
        case AST_NODE_OPERATOR:
            sprintf(str, "tmp%d", temp_var_cnt++);
            r = var_store(
                    symbol_table_entry_init(str, 1, INT, 0, scope),
                    &scope,
                    f);
            // its normal to have r16 as input reg in nor as its not used
            sprintf(str,"%s r%d r%d r%d;",
                    print_ast_op_type(node->operator.op),
                    r,
                    ast_node_to_asm((ast_node *) node->operator.left, args),
                    node->operator.right == NULL
                        ? R_NONE
                        : ast_node_to_asm((ast_node *) node->operator.right, args)
                    );
            FWRITE(str);
            return r;
        case AST_NODE_SYMBOL:
            return var_retrieve(node->symbol.entry,f);
        case AST_NODE_WHILE:
            open_scope(&scope);
            FWRITE("# WHILE COND");
            sprintf(str, "__WHILE_LOOP_%d__", scope);
            FWRITE(str);
            ast_node_to_asm((ast_node *) node->while_block.cond, args);
            sprintf(str, "JMPNE __WHILE_END_%d__;", scope);
            FWRITE(str);

            ast_node_to_asm((ast_node *) node->while_block.loop, args);
            sprintf(str, "JMP __WHILE_LOOP_%d__;", scope);
            FWRITE(str);
            sprintf(str, "__WHILE_END_%d__", scope);
            FWRITE(str);
            close_scope(&scope, f);
            break;
        case AST_NODE_FUNCTION_ARGS:
            open_scope(&scope);
            for (int i = 0; i < MAX_FUNCTION_ARGS; i++) {
                reg_push(i,f);
                ast_node* arg = (ast_node *) node->function_args.args[i];
                if (arg != NULL) {
                    if ( arg->type != AST_NODE_SYMBOL) {
                        printf("Function arguments cant be an expression %s\n", __PRETTY_FUNCTION__ );
                        exit(-1);
                    }
                    ast_node_to_asm(arg, args);
                }
            }
            close_scope(&scope, f);
            break;
        case AST_NODE_RETURN:
            reg_push(R0,f);
            open_scope(&scope);
            sprintf(str,"MOV r%d r%d;", R0, ast_node_to_asm((ast_node *) node->ret.value, args));
            FWRITE(str);
            close_scope(&scope, f);
            touch_reg(R0, symbol_table_entry_init("temp_ret", 1, INT, 0, scope+1));
            break;
        case AST_NODE_FUNCTION:
            sprintf(str, "# FUNCTION %s", ((ast_node*) node->function.name)->symbol.entry->symbol);
            FWRITE(str);
            sprintf(str, "__FUNCTION_%s__", ((ast_node*) node->function.name)->symbol.entry->symbol);
            FWRITE(str);
            ast_node_to_asm((ast_node *) node->function.args, args);
            if(node->function.expr != NULL)
                ast_node_to_asm((ast_node *) node->function.expr, args);
            sprintf(str, "temp_lr");
            open_scope(&scope);
            r = var_store(
                    symbol_table_entry_init(str, 1, INT, 0, scope),
                    &scope,
                    f);
            sprintf(str, "LOAD r%d SP;",r);
            FWRITE(str);
            close_scope(&scope, f);
            sprintf(str, "JMP r%d;",r);
            FWRITE(str);
            sprintf(str, "# __END_FUNCTION_%s__", ((ast_node*) node->function.name)->symbol.entry->symbol);
            FWRITE(str);

            break;
        case AST_NODE_FUNCTION_CALL:
            FWRITE("STR LR");
            sprintf(str, "JMP __FUNCTION_%s__;", ((ast_node*) node->function_call.entry)->symbol.entry->symbol);
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

    compiler_args args = {
            f,
            NULL
    };
    ast_node_to_asm(root->root, &args);
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
                ast_node_print((ast_node *) node->variable_definition.value, tabs + 1);
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
            ast_node_print((ast_node *) node->expression.node, tabs + 1);
            if (node->expression.next != NULL)
                ast_node_print((ast_node *) node->expression.next, tabs + 1);
            break;
        case AST_NODE_IF:
            printf("%s AST_NODE_IF: \n",tab);
            ast_node_print((ast_node *) node->if_block.cond, tabs + 1);
            ast_node_print((ast_node *) node->if_block.then_block, tabs + 1);
            if (node->if_block.else_block != NULL)
                ast_node_print((ast_node *) node->if_block.else_block, tabs + 1);
            break;
        case AST_NODE_OPERATOR:
            printf("%s AST_NODE_OPERATOR: %s\n",tab, print_ast_op_type(node->operator.op));
            ast_node_print((ast_node *) node->operator.left, tabs + 1);
            if(node->operator.right != NULL)
                ast_node_print((ast_node *) node->operator.right, tabs + 1);
            break;
        case AST_NODE_SYMBOL:
            printf("%s AST_NODE_SYMBOL: %s\n",tab, node->symbol.entry->symbol);
            break;
        case AST_NODE_WHILE:
            printf("%s AST_NODE_WHILE: \n",tab);
            if (node->while_block.loop != NULL)
                ast_node_print((ast_node *) node->while_block.loop, tabs + 1);
            else printf("PASS\n");
            break;
        case AST_NODE_FUNCTION_ARGS:
            printf("%s AST_NODE_FUNCTION_ARGS: \n",tab);
            for (int i = 0; i < MAX_FUNCTION_ARGS; i++) {
                if (node->function_args.args[i] != NULL)
                    ast_node_print((ast_node *) node->function_args.args[i], tabs + 1);
            }
            break;
        case AST_NODE_RETURN:
            printf("%s AST_NODE_RETURN: \n",tab);
            ast_node_print((ast_node *) node->ret.value, tabs + 1);
            break;
        case AST_NODE_FUNCTION:
            printf("%s AST_NODE_FUNCTION: \n",tab);
            ast_node_print((ast_node *) node->function.args, tabs + 1);
            if (node->function.expr != NULL)
                ast_node_print((ast_node *) node->function.expr, tabs + 1);
            break;
        case AST_NODE_FUNCTION_CALL:
            printf("%s AST_NODE_FUNCTION_CALL: \n",tab);
            ast_node_print((ast_node *) node->function_call.function_args, tabs + 1);
            ast_node_print((ast_node *) node->function_call.entry, tabs + 1);
            break;
    }
    printf("%s}\n", tab);
}

void ast_print(ast_root* root) {
    ast_node_print(root->root,0);
}
