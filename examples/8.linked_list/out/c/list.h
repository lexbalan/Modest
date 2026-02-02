
#ifndef LIST_H
#define LIST_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdlib.h>
#include <stdio.h>


struct node {
	struct node *next;
	struct node *prev;
	void *data;
};

struct list {
	struct node *head;
	struct node *tail;
	uint32_t size;
};
struct list *list_create(void);
uint32_t list_size_get(struct list *list);
struct node *list_first_node_get(struct list *list);
struct node *list_last_node_get(struct list *list);
struct node *list_node_first(struct list *list, struct node *new_node);
struct node *list_node_create(void);
struct node *list_node_next_get(struct node *node);
struct node *list_node_prev_get(struct node *node);
void *list_node_data_get(struct node *node);
void list_node_insert_right(struct node *left, struct node *new_right);
struct node *list_node_get(struct list *list, int32_t pos);
struct node *list_node_insert(struct list *list, int32_t pos, struct node *new_node);
struct node *list_node_append(struct list *list, struct node *new_node);
struct node *list_insert(struct list *list, int32_t pos, void *data);
struct node *list_append(struct list *list, void *data);

#endif /* LIST_H */
