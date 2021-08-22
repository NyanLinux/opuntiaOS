#include <libobjc/objc.h>
#include <libobjc/runtime.h>
#include <libobjc/selector.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static struct objc_selector* selector_pool_start;
static struct objc_selector* selector_pool_next;

#define CONST_DATA true
#define VOLATILE_DATA false

static SEL selector_table_add(char* name, const char* types, bool const_data)
{
    // Checking if we have this selector
    for (struct objc_selector* cur_sel = selector_pool_start; cur_sel != selector_pool_next; cur_sel++) {
        if (strcmp(name, (char*)cur_sel->id) == 0) {
            if (cur_sel->types == 0 || types == 0) {
                if (cur_sel->types == types) {
                    return (SEL)cur_sel; 
                }
            } else {
                if (strcmp(types, cur_sel->types)) {
                    return (SEL)cur_sel;
                }
            }
        } 
    }

    SEL sel = (SEL)selector_pool_next++;
    if (const_data) {
        sel->id = name;
        sel->types = types;
    } else {
        int name_len = strlen(name);
        char* name_data = (char*)malloc(name_len + 1);
        memcpy(name_data, name, name_len);
        name_data[name_len] = '\0';
        sel->id = name_data;

        if (types) {
            int types_len = strlen(types);
            char* types_data = (char*)malloc(types_len + 1);
            memcpy(types_data, types, types_len);
            types_data[types_len] = '\0';
            sel->types = types_data;
        }
    }

    return sel;
}

// TODO: We currently do it really stupid
void selector_table_init()
{
    selector_pool_start = selector_pool_next = (struct objc_selector*)malloc(1024);
}


void selector_add_from_module(struct objc_selector* selectors)
{
    for (int i = 0; selectors[i].id; i++) {
        char* name = (char*)selectors[i].id;
        const char* types = selectors[i].types;
        selector_table_add(name, types, CONST_DATA);
    }
}

void selector_add_from_method_list(struct objc_method_list* method_list)
{
    for (int i = 0; i < method_list->method_count; i++) {
        Method method = &method_list->method_list[i];
        if (method->method_name) {
            char* name = (char*)method->method_name;
            const char* types = method->method_types;
            OBJC_DEBUGPRINT("    method %s %s\n", name, types);
            method->method_name = selector_table_add(name, types, CONST_DATA);
        }
    }
}

void selector_add_from_class(Class cls)
{
    for (struct objc_method_list* ml = cls->methods; ml; ml = ml->method_next) {
        selector_add_from_method_list(ml);
    }
}