
#ifndef LIST_H
#define LIST_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdlib.h>
#include <stdio.h>



struct list_node;






struct list_node {
	struct list_node *next;
	struct list_node *prev;
	void *data;
};


struct list_list {
	struct list_node *head;
	struct list_node *tail;
	uint32_t size;
};
struct list_list *list_create(void);
uint32_t list_size_get(struct list_list *list);
struct list_node *list_first_node_get(struct list_list *list);
struct list_node *list_last_node_get(struct list_list *list);
struct list_node *list_node_first(struct list_list *list, struct list_node *new_node);
struct list_node *list_node_create(void);
struct list_node *list_node_next_get(struct list_node *node);
struct list_node *list_node_prev_get(struct list_node *node);
void *list_node_data_get(struct list_node *node);
void list_node_insert_right(struct list_node *left, struct list_node *new_right);
struct list_node *list_node_get(struct list_list *list, int32_t pos);
struct list_node *list_node_insert(struct list_list *list, int32_t pos, struct list_node *new_node);
struct list_node *list_node_append(struct list_list *list, struct list_node *new_node);
struct list_node *list_insert(struct list_list *list, int32_t pos, void *data);
struct list_node *list_append(struct list_list *list, void *data);

#endif /* LIST_H */
