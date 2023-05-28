//
// Created by joel on 26/05/23.
//
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symbol_table.h"
#include "mem_manager.h"

#define REGS_SIZE 16
static symbol_table_entry* regs[REGS_SIZE];

reg_t get_reg(symbol_table_entry* entry) {
    if (entry == NULL) {
        printf("entry not initialised %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    // we subtract 2 bc of SP and LR
    for (int i = 0; i < REGS_SIZE - 2; i++) {
        if (regs[i] == NULL) {
            regs[i] = entry;
            return i;
        }
    }
    return R_NONE;
}

void free_reg(reg_t reg) {
    regs[reg] = NULL;
}

void free_regs(int scope) {
    for (int i = 0; i < REGS_SIZE; i++) {
        if (regs[i] != NULL && regs[i]->scope >= scope) {
            regs[i] = NULL;
        }
    }
}

reg_t find_reg(symbol_table_entry* entry) {
    if (entry == NULL) {
        printf("entry not initialised %s\n", __PRETTY_FUNCTION__ );
        return R_NONE;
    }
    for (int i = 0; i < REGS_SIZE; i++) {
        if (0 == strcmp(regs[i]->symbol, entry->symbol) && regs[i]->scope == entry->scope) {
            return i;
        }
    }
}

int stack_push(symbol_table_entry* entry) {
    if (entry == NULL) {
        printf("entry not initialised %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    for (int i = 0; i < STACK_SIZE; i++) {
        if (stak[i] != NULL) {
            stak[i] = entry;
            return i;
        }
    }
    return -1;
}
symbol_table_entry* stack_pop() {
    if (stak[0] == NULL) {
        printf("stack is empty %s\n", __PRETTY_FUNCTION__ );
        return NULL;
    }
    for (int i = 0; i < STACK_SIZE; ++i) {
        if (stak[i] != NULL) {
            symbol_table_entry *tmp = stak[i-1];
            stak[i-1] = NULL;
            return tmp;
        }
    }
    printf("stack is full %s\n", __PRETTY_FUNCTION__ );
    return NULL;
}
int stack_find(symbol_table_entry* entry) {
    for (int i = 0; i < STACK_SIZE; ++i) {
        if (stak[i] != NULL) {
            if (stak[i] == entry) {
                return i;
            }
        }
    }
    return -1;
}

reg_t store(symbol_table_entry* entry) {
    if (entry == NULL) {
        printf("entry not initialised %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    get_reg(entry);
}
reg_t retrieve(symbol_table_entry* entry);
