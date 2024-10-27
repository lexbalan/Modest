// ./out/c/list.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "list.h"









list_List *list_create()
{
	list_List *const list = (list_List *)malloc(sizeof(list_List));

	if (list == NULL) {
		return NULL;
	}

	*list = (list_List){};

	return (list_List *)list;
}

uint32_t list_size_get(list_List *list)
{
	if (list == NULL) {
		return 0;
	}

	return list->size;
}

list_Node *list_first_node_get(list_List *list)
{
	if (list == NULL) {
		return NULL;
	}

	return (list_Node *)list->head;
}

list_Node *list_last_node_get(list_List *list)
{
	if (list == NULL) {
		return NULL;
	}

	return (list_Node *)list->tail;
}

list_Node *list_node_first(list_List *list, list_Node *new_node)
{
	if ((list == NULL) || (new_node == NULL)) {
		return NULL;
	}

	list->head = (list_Node *)new_node;
	list->tail = (list_Node *)new_node;

	list->size = list->size + 1;

	return (list_Node *)new_node;
}

list_Node *list_node_create()
{
	list_Node *const node = (list_Node *)malloc(sizeof(list_Node));

	if (node == NULL) {
		return NULL;
	}

	*node = (list_Node){};

	return (list_Node *)node;
}

list_Node *list_node_next_get(list_Node *node)
{
	if (node == NULL) {
		return NULL;
	}

	return (list_Node *)node->next;
}

list_Node *list_node_prev_get(list_Node *node)
{
	if (node == NULL) {
		return NULL;
	}

	return (list_Node *)node->prev;
}

void *list_node_data_get(list_Node *node)
{
	if (node == NULL) {
		return NULL;
	}

	return node->data;
}

void list_node_insert_right(list_Node *left, list_Node *new_right)
{
	printf("node_insert_right\n");

	list_Node *const old_right = left->next;
	left->next = (list_Node *)new_right;

	if (old_right != NULL) {
		old_right->prev = (list_Node *)new_right;
	}

	new_right->next = (list_Node *)old_right;
	new_right->prev = (list_Node *)left;
}

list_Node *list_node_get(list_List *list, int32_t pos)
{
	if ((list == NULL) || (list->size == 0)) {
		return NULL;
	}

	printf("node_get(%d)\n", pos);
	list_Node *node;

	if (pos >= 0) {
		// go forward
		node = (list_Node *)list->head;
		const uint32_t n = (uint32_t)pos;

		if (n > list->size) {
			return NULL;
		}

		uint32_t i;
		i = 0;
		while (i < n) {
			node = (list_Node *)node->next;
			i = i + 1;
		}
	} else {
		// go backward
		node = (list_Node *)list->tail;
		const uint32_t n = (uint32_t)-pos - 1;

		if (n > list->size) {
			return NULL;
		}

		uint32_t i;
		i = 0;
		while (i < n) {
			node = (list_Node *)node->prev;
			i = i + 1;
		}
	}

	return (list_Node *)node;
}

list_Node *list_node_insert(list_List *list, int32_t pos, list_Node *new_node)
{
	if ((list == NULL) || (new_node == NULL)) {
		return NULL;
	}

	printf("node_insert(%d)\n", pos);


	list_Node *const n = list_node_get((list_List *)list, pos);

	if (n == NULL) {
		return NULL;
	}

	list_Node *const nod = list_node_prev_get((list_Node *)n);

	if (nod == NULL) {
		return NULL;
	}

	list_node_insert_right((list_Node *)nod, (list_Node *)new_node);
	list->size = list->size + 1;

	return (list_Node *)new_node;
}

list_Node *list_node_append(list_List *list, list_Node *new_node)
{
	if ((list == NULL) || (new_node == NULL)) {
		return NULL;
	}

	if (list->tail == NULL) {
		list->head = (list_Node *)new_node;
	} else {
		list_node_insert_right((list_Node *)list->tail, (list_Node *)new_node);
	}

	list->tail = (list_Node *)new_node;

	list->size = list->size + 1;

	return (list_Node *)new_node;
}

list_Node *list_insert(list_List *list, int32_t pos, void *data)
{
	list_Node *const new_node = list_node_create();

	if (new_node == NULL) {
		return NULL;
	}

	new_node->data = data;

	return (list_Node *)list_node_insert((list_List *)list, pos, (list_Node *)new_node);
}

list_Node *list_append(list_List *list, void *data)
{
	if (list == NULL) {
		return NULL;
	}

	list_Node *const new_node = list_node_create();

	if (new_node == NULL) {
		return NULL;
	}

	new_node->data = data;

	list_Node *const node = list_node_append((list_List *)list, (list_Node *)new_node);

	if (node == NULL) {
		free(new_node);
	}

	return (list_Node *)node;
}
