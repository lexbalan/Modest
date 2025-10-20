// examples/8.linked_list/linked_list.cm

#ifndef LIST_H
#define LIST_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdlib.h>
#include <stdio.h>



struct list_Node;
typedef struct list_Node list_Node;

struct list_Node {
	list_Node *next;
	list_Node *prev;
	void *data;
};

struct list_List {
	list_Node *head;
	list_Node *tail;
	uint32_t size;
};
typedef struct list_List list_List;
list_List *list_create();
uint32_t list_size_get(list_List *list);
list_Node *list_first_node_get(list_List *list);
list_Node *list_last_node_get(list_List *list);
list_Node *list_node_first(list_List *list, list_Node *new_node);
list_Node *list_node_create();
list_Node *list_node_next_get(list_Node *node);
list_Node *list_node_prev_get(list_Node *node);
void *list_node_data_get(list_Node *node);
void list_node_insert_right(list_Node *left, list_Node *new_right);
list_Node *list_node_get(list_List *list, int32_t pos);
list_Node *list_node_insert(list_List *list, int32_t pos, list_Node *new_node);
list_Node *list_node_append(list_List *list, list_Node *new_node);
list_Node *list_insert(list_List *list, int32_t pos, void *data);
list_Node *list_append(list_List *list, void *data);

#endif /* LIST_H */
