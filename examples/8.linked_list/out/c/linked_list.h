
#ifndef LINKED_LIST_H
#define LINKED_LIST_H

#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/linked_list/linked_list.hm

struct List;
typedef struct List List;
struct Node;
typedef struct Node Node;

List *linked_list_create(void);
uint32_t linked_list_size_get(List *list);
Node *linked_list_first_get(List *list);
Node *linked_list_last_get(List *list);

Node *linked_list_node_create(void);
Node *linked_list_node_prev_get(Node *node);
Node *linked_list_node_next_get(Node *node);
void *linked_list_node_link_get(Node *node);

Node *linked_list_insert_node(List *list, Node *new_node);

Node *linked_list_insert(List *list, void *link);

#endif  /* LINKED_LIST_H */
