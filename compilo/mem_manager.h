//
// Created by joel on 26/05/23.
//

#ifndef COMPILO_MEM_MANAGER_H
#define COMPILO_MEM_MANAGER_H

#include "symbol_table.h"
#define STACK_SIZE 2048

// order is important
enum {
    R0,
    R1,
    R2,
    R3,
    R4,
    R5,
    R6,
    R7,
    R8,
    R9,
    R10,
    R11,
    R12,
    R13,
    SP,
    LR,
    R_NONE = -1
} typedef reg_t;


reg_t get_reg(symbol_table_entry* entry);
void free_reg(reg_t reg);
/** provide the scope of the values to be cleaned:
 * Ex: if you provide 3, all the values having scope 3 or more will free their registers
 */
void free_regs(int scope);

reg_t find_reg(symbol_table_entry* entry);

int stack_alloc(symbol_table_entry* entry, FILE* f);
symbol_table_entry* stack_pop();
int stack_find(symbol_table_entry* entry);
reg_t var_retrieve(symbol_table_entry* entry, FILE* f);
reg_t reg_push(reg_t r, FILE* f);
reg_t reg_pop(reg_t r, FILE* f);

/**
 *
 * @param entry
 * @param scope Optional parameter, nullable read reference
 * @param f out_file
 * @return
 */
reg_t var_store(symbol_table_entry* entry, const int* scope, FILE* f);
reg_t retrieve(symbol_table_entry* entry);

void open_scope(int* scope);
void close_scope(int* scope, FILE* f);

#endif //COMPILO_MEM_MANAGER_H
