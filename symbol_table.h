
#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <bits/types/FILE.h>

#define TABLE_ALLOC_BLOCK 1024
#define  INT_SIZE 4
#define MAX_SIZE_STR 420

union u_symbol_table_entry {
    char *name;
    int value;
};

enum variable_type { INT , VOID};

struct {
    char* symbol;
    char is_initialised;
    enum variable_type variable_type;
    int offset;
    int scope;
} typedef symbol_table_entry;

struct {
    symbol_table_entry** symbol_table;
    unsigned int size;
    unsigned int allocated_size;
} typedef symbol_table;


void free_symbol_table_entry(symbol_table_entry** entry);
symbol_table* symbol_table_init();
void free_symbol_table(symbol_table** table);
void symbol_table_push(symbol_table* table, symbol_table_entry* entry); //push a symbol to the table
symbol_table_entry* symbol_table_pop(symbol_table* table,int* offset); // pop a symbol from the table
symbol_table_entry* symbol_table_get(int index, symbol_table* table);
symbol_table_entry* symbol_table_get_by_symbol(char* symbol, symbol_table* table);

symbol_table_entry* symbol_table_entry_init(char* name, char is_init, enum variable_type variable_type, int offset, int scope);


void symbol_table_print(symbol_table* table);
void symbol_entry_print(symbol_table_entry* entry); 
void pop_scope(int* scope,int* offset, symbol_table* table);
void push_element(symbol_table* table,char* name, char is_init, enum variable_type variable_type, int* offset, int scope);
void write_assembly(char* instruction, int arg1_offset,int arg2_offset, FILE* file);
void write_assembly_single(char* instruction,FILE* file);
void write_assembly_3(char* instruction, int arg1_offset,int arg2_offset,int arg3_offset, FILE* file);
#endif

