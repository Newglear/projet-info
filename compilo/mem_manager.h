//
// Created by joel on 26/05/23.
//

#ifndef COMPILO_MEM_MANAGER_H
#define COMPILO_MEM_MANAGER_H

#include "symbol_table.h"

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
} typedef reg_t;

reg_t get_reg(symbol_table_entry* entry);
void free_reg(reg_t reg);

#endif //COMPILO_MEM_MANAGER_H
