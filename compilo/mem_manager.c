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
    printf("Not enough registers to execute the program\n");
    exit(-1);
}

void free_reg(reg_t reg) {
    regs[reg] = NULL;
}