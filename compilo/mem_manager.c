//
// Created by joel on 26/05/23.
//
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "symbol_table.h"
#include "mem_manager.h"
#include "ast.h"

#define REGS_SIZE 16
static symbol_table_entry* regs[REGS_SIZE];
static reg_t last_used_reg[REGS_SIZE];
static int last_used_reg_index;

static symbol_table_entry* stak[2048];
static sp;
/**
 * increments the index of the reg, it indicates that the reg has been
 * used, a higher reg index number indicates a more recent use of the reg
 * @param reg
 */
reg_t touch_reg(reg_t reg, symbol_table_entry* entry) {
    if (entry != NULL) {
        regs[reg] = entry;
    }
    last_used_reg[reg] = last_used_reg_index++;
    return reg;
}

reg_t get_reg(symbol_table_entry* entry) {
    if (entry == NULL) {
        printf("entry not initialised %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    // we subtract 2 bc of SP and LR
    for (int i = 0; i < REGS_SIZE - 2; i++) {
        if (regs[i] == NULL) {
            regs[i] = entry;
            reg_t r = i;
            return touch_reg(r, NULL);
        }
    }
    printf("cant get a reg %s\n", __PRETTY_FUNCTION__ );
    return R_NONE;
}

void free_reg(reg_t reg) {
    regs[reg] = NULL;
    last_used_reg[reg] = 0;
}

void free_regs(int scope) {
    for (int i = 0; i < REGS_SIZE; i++) {
        if (regs[i] != NULL && regs[i]->scope >= scope) {
            regs[i] = NULL;
            last_used_reg[i] = 0;
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
            return touch_reg(i, NULL);
        }
    }
    return R_NONE;
}

int stack_alloc(symbol_table_entry* entry, FILE* f) {
    if (entry == NULL) {
        printf("entry not initialised %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    stak[sp] = entry;
    char str[MAX_SIZE_STR] ="";
    sprintf(str,"ADD SP SP 1;");
    FWRITE(str);
    sp++;
    return sp;
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

reg_t least_used_reg() {
    int min = last_used_reg_index;
    int least_used_reg = 0;
    // -2 bc SP and LR
    for (int i = 0; i < REGS_SIZE -2; i++) {
        if (last_used_reg[i] < min) {
            min = last_used_reg[i];
            least_used_reg = i;
        }
    }
    return least_used_reg;
}

reg_t stack_store(symbol_table_entry* entry,FILE* f) {
    reg_t r = find_reg(entry);
    for (int i = 0; i < STACK_SIZE -2; ++i) {
        if (stak[i] == entry) {
            char str[MAX_SIZE_STR] = "";
            sprintf(str, "STR %d r%d;", i, r);
            FWRITE(str);
        }
    }
    free_reg(r);
    return r;
}

reg_t var_store(symbol_table_entry* entry, const int* scope, FILE* f) {
    if (entry == NULL) {
        printf("entry not initialised %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    if (scope != NULL) {
        entry->scope = *scope;
    }
    reg_t reg = get_reg(entry);
    stack_alloc(entry, f);
    if (reg != R_NONE) {
        return touch_reg(reg, NULL);
    }
    reg_t least_used = least_used_reg();
    if (regs[least_used] != NULL) {
        stack_store(regs[least_used],f);
    }
    return touch_reg(least_used, entry);
}

reg_t retrieve(symbol_table_entry* entry) {

}
