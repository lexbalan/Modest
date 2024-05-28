// examples/8.linked_list/linked_list.hm

#ifndef LINKED_LIST_H
#define LINKED_LIST_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>


struct List;
typedef struct List List;
struct Node;
typedef struct Node Node;

List *linked_list_create();
uint32_t linked_list_size_get(List *list);
Node *linked_list_first_get(List *list);
Node *linked_list_last_get(List *list);

Node *linked_list_node_create();
Node *linked_list_node_prev_get(Node *node);
Node *linked_list_node_next_get(Node *node);
void *linked_list_node_data_get(Node *node);

Node *linked_list_node_append(List *list, Node *new_node);

Node *linked_list_append(List *list, void *data);

#endif /* LINKED_LIST_H */
