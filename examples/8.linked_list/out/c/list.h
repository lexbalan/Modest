
#ifndef LIST_H
#define LIST_H

#include <stdint.h>
#include <stdbool.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>


struct Node;
typedef struct Node Node;


struct Node {
	Node *next;
	Node *prev;
	void *data;
};
struct List {
	Node *head;
	Node *tail;
	uint32_t size;
};
typedef struct List List;
List *list_create();
uint32_t list_size_get(List *list);
Node *list_first_node_get(List *list);
Node *list_last_node_get(List *list);
Node *list_node_first(List *list, Node *new_node);
Node *list_node_create();
Node *list_node_next_get(Node *node);
Node *list_node_prev_get(Node *node);
void *list_node_data_get(Node *node);
void list_node_insert_right(Node *left, Node *new_right);
Node *list_node_get(List *list, int32_t pos);
Node *list_node_insert(List *list, int32_t pos, Node *new_node);
Node *list_node_append(List *list, Node *new_node);
Node *list_insert(List *list, int32_t pos, void *data);
Node *list_append(List *list, void *data);

#endif /* LIST_H */
