#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



symbol_table* symbol_table_init() {
    symbol_table* tp = malloc(sizeof(symbol_table));
    symbol_table table = {
            .symbol_table = malloc(sizeof(void*)*TABLE_ALLOC_BLOCK),
            .size = 0,
            .allocated_size = TABLE_ALLOC_BLOCK
    };
    *tp = table;
    return tp;
}

void free_symbol_table_entry(symbol_table_entry** entry) {
    if (entry == NULL) {
        printf("table not initialised %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    if (*entry == NULL) {
        printf("table not initialised %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    free((*entry));
    *entry = NULL;
}

void free_symbol_table(symbol_table** table) {
    if(table == NULL) {
        printf("table not initialised %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    if (*table == NULL) {
        printf("table not initialised %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    for (int i = 0; i < (*table)->size; i++) {
        symbol_table_entry** entry = (*table)->symbol_table + i*sizeof(symbol_table_entry);
        free_symbol_table_entry(entry);
    }
    free((*table)->symbol_table);
    table = NULL;
}

//push a symbol to the table
void symbol_table_push(symbol_table* table, symbol_table_entry* entry) {
    if (table == NULL) {
        printf("table not initialised %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    if (table->size < table->allocated_size) {
        table->symbol_table[table->size] = entry;
        table->size++;
    } else {
        void* p = realloc(table->symbol_table, table->allocated_size + TABLE_ALLOC_BLOCK);
        if(p == NULL) {
            printf("realloc failed %s\n", __PRETTY_FUNCTION__ );
            exit(-1);
        }
        table->symbol_table = p;
        table->allocated_size = table->allocated_size + TABLE_ALLOC_BLOCK;
        table->symbol_table[table->size] = entry;
    }
}

// pop a symbol from the table
symbol_table_entry* symbol_table_pop(symbol_table* table) {

    if (!table){  // check if the table is initialized
        printf("Table not initialized %s \n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    unsigned int index = table->size -1;
    if (!table->size){  // check if the table is initialized
        printf("No element in the table %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    symbol_table_entry* elem = table->symbol_table[index];
    table->symbol_table[index] = NULL;
    table->size--;
    return elem;
}

symbol_table_entry* symbol_table_get(int index, symbol_table* table) { // indexes start from 0 don't forget :p
    if (!table){  // check if the table is initialized
        printf("Table not initialized %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    if(index >= table->size){
        printf("Index out of range\n");
        exit(-1);
    }
    return table->symbol_table[index];
}

/**
 * Returns the element matching the symbol name or NULL if the element is not found
 * @param symbol
 * @param table
 * @return symbol_table* | NULL
 */
symbol_table_entry* symbol_table_get_by_symbol(char* symbol, symbol_table* table) {
    if (!table) {
        printf("Table not initialized %s\n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    if(!symbol) {
        printf("Symbol not initialized in %s \n", __PRETTY_FUNCTION__ );
        exit(-1);
    }
    for (int i = 0; i < table->size; ++i) {
        symbol_table_entry* entry = table->symbol_table[i];
        if (strcmp(entry->symbol, symbol) == 0) {
            return entry;
        }
    }
    return NULL;
}


void symbol_entry_print(symbol_table_entry* entry) {
    printf("{symbol: %s,is_initialised %d,variable_type: %d, offset: %d, scope: %d}\n", entry->symbol, entry->is_initialised, entry->variable_type, entry->offset, entry->scope);
}

void symbol_table_print(symbol_table* table) {
    if (!table) {
        printf("Table not initialized in %s\n", __PRETTY_FUNCTION__);
        exit(-1);
    }
    printf("[\n");
    for (int i = 0; i < table->size; ++i) {
        symbol_table_entry *entry = table->symbol_table[i];
        symbol_entry_print(entry);
    }
    printf("]\n");
}

symbol_table_entry* symbol_table_entry_init(char* name, char is_init, enum variable_type variable_type, int offset, int scope) {
    char* symbol = malloc(sizeof(char)*strlen(name));
    strcpy(symbol, name);
    symbol_table_entry s = {
            .symbol = symbol,
            .is_initialised = is_init,
            .variable_type = variable_type,
            .offset = offset,
            .scope = scope
    };
    symbol_table_entry* sp = malloc(sizeof(symbol_table_entry));
    *sp = s;
    return sp;
}


void pop_scope(int* scope,int* offset, symbol_table* table){
    if (!table) {
        printf("Table not initialized in %s\n", __PRETTY_FUNCTION__);
        exit(-1);
    }
    symbol_table_entry* element = symbol_table_get(table->size-1,table);

    while(element->scope == *scope){
        printf("POP! \n");
        symbol_entry_print(element);
        symbol_table_pop(table);
        element = symbol_table_get(table->size-1,table);
        *offset-=INT_SIZE;
    }

    (*scope)--;
}

void push_element(symbol_table* table,char* name, char is_init, enum variable_type variable_type, int* offset, int scope){
    symbol_table_entry* e = symbol_table_entry_init(name,is_init,variable_type,*offset,scope);
    symbol_table_push(table,e);
    *offset += INT_SIZE;
}

void write_assembly(char* instruction, int arg1_offset,int arg2_offset, FILE* file) {
    char str[MAX_SIZE_STR]= "";
    char addr[MAX_SIZE_STR]= "";
    strcat(str,instruction);
    sprintf(addr," %d ",arg1_offset); 
    strcat(str,addr); 
    sprintf(addr," %d;\n",arg2_offset); 
    strcat(str,addr);
    fwrite(str,sizeof(char),strlen(str),file);
}

void flow_control_push(char* word,symbol_table* table, int scope, FILE* file) {
    static unsigned int flow_control_counter = 0;
    char str[MAX_SIZE_STR] = "";
    char tmp[MAX_SIZE_STR] = "";
    if (!table) {
        printf("Table not initialized in %s\n", __PRETTY_FUNCTION__);
        exit(-1);
    }
    if(!word) {
        printf("Word not initialized in %s \n", __PRETTY_FUNCTION__ );
        exit(-1);
    }

    strcat(str,"__");
    strcat(str, word);
    sprintf(tmp,"_%d", flow_control_counter++);
    strcat(str, tmp);
    strcat(str, "__:\n");

    symbol_table_entry* e = symbol_table_entry_init(str, 0, 0, 0, scope);
    symbol_table_push(table,e);

    fwrite(str,sizeof(char),strlen(str),file);
}

// TODO pop last of corect type???
void flow_control_get(symbol_table* table, FILE* file) {
    if (!table) {
        printf("Table not initialized in %s\n", __PRETTY_FUNCTION__);
        exit(-1);
    }
    // TODO
    symbol_table_entry* e = symbol_table_get(table->size-1,table);
    fwrite(e->symbol,sizeof(char),strlen(e->symbol),file);
}

void flow_control_pop(symbol_table* table,int* scope, FILE* file) {
    if (!table) {
        printf("Table not initialized in %s\n", __PRETTY_FUNCTION__);
        exit(-1);
    }
    (*scope)--;
    flow_control_get(table,file);
    symbol_table_pop(table);
}
