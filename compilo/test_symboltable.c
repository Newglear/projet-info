//
// Created by joel on 06/04/23.
//
#include "symbol_table.h"
#include <stdio.h>

int main(){
    symbol_table table = symbol_table_init();
    symbol_table_print(&table);
    symbol_table_entry a = {"a", 0, INT,0,0};
    symbol_table_push(&table,&a);
    symbol_table_push(&table,&a);
    symbol_table_print(&table);
    symbol_table_pop(&table);
    symbol_table_print(&table);
    symbol_table_entry* t = symbol_table_get(0,&table);
    symbol_entry_print(t);

    printf("Found: ");
    symbol_entry_print(symbol_table_get_by_symbol("a",&table));

    symbol_table_entry* b = symbol_table_get(1,&table);
    symbol_entry_print(b);
    // TODO: FREE
}
