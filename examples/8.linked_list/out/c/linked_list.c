// examples/8.linked_list/linked_list.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>




#include "./linked_list.h"


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


List *linked_list_create()
{
	List *const list = (List *)malloc(sizeof(List));

	if (list == NULL) {
		return NULL;
	}

	*list = (List){};

	return list;
}


uint32_t linked_list_size_get(List *list)
{
	if (list == NULL) {
		return 0;
	}

	return list->size;
}


Node *linked_list_first_node_get(List *list)
{
	if (list == NULL) {
		return NULL;
	}

	return list->head;
}


Node *linked_list_last_node_get(List *list)
{
	if (list == NULL) {
		return NULL;
	}

	return list->tail;
}


Node *linked_list_node_first(List *list, Node *new_node)
{
	if ((list == NULL) || (new_node == NULL)) {
		return NULL;
	}

	list->head = new_node;
	list->tail = new_node;

	list->size = list->size + 1;

	return new_node;
}



Node *linked_list_node_create()
{
	Node *const node = (Node *)malloc(sizeof(Node));

	if (node == NULL) {
		return NULL;
	}

	*node = (Node){};

	return node;
}


Node *linked_list_node_next_get(Node *node)
{
	if (node == NULL) {
		return NULL;
	}

	return node->next;
}


Node *linked_list_node_prev_get(Node *node)
{
	if (node == NULL) {
		return NULL;
	}

	return node->prev;
}


void *linked_list_node_data_get(Node *node)
{
	if (node == NULL) {
		return NULL;
	}

	return node->data;
}


void node_insert_right(Node *left, Node *new_right)
{
	printf("node_insert_right\n");

	Node *const old_right = left->next;
	left->next = new_right;

	if (old_right != NULL) {
		old_right->prev = new_right;
	}

	new_right->next = old_right;
	new_right->prev = left;
}


// get list node by number
// if number is out of range returns nil
// if number < 0 - go backward
Node *linked_list_node_get(List *list, int32_t pos)
{
	if ((list == NULL) || (list->size == 0)) {
		return NULL;
	}

	printf("linked_list_node_get(%d)\n", pos);
	Node *node;

	if (pos >= 0) {
		// go forward
		node = list->head;
		const uint32_t n = (uint32_t)pos;

		if (n > list->size) {
			return NULL;
		}

		uint32_t i;
		i = 0;
		while (i < n) {
			node = node->next;
			i = i + 1;
		}
	} else {
		// go backward
		node = list->tail;
		const uint32_t n = (uint32_t)-pos - 1;

		if (n > list->size) {
			return NULL;
		}

		uint32_t i;
		i = 0;
		while (i < n) {
			node = node->prev;
			i = i + 1;
		}
	}

	return node;
}


Node *linked_list_node_insert(List *list, int32_t pos, Node *new_node)
{
	if ((list == NULL) || (new_node == NULL)) {
		return NULL;
	}

	printf("linked_list_node_insert(%d)\n", pos);


	Node *const n = linked_list_node_get(list, pos);

	if (n == NULL) {
		return NULL;
	}

	Node *const nod = linked_list_node_prev_get(n);

	if (nod == NULL) {
		return NULL;
	}

	node_insert_right(nod, new_node);
	list->size = list->size + 1;

	return new_node;
}



Node *linked_list_node_append(List *list, Node *new_node)
{
	if ((list == NULL) || (new_node == NULL)) {
		return NULL;
	}

	if (list->tail == NULL) {
		list->head = new_node;
	} else {
		node_insert_right(list->tail, new_node);
	}

	list->tail = new_node;

	list->size = list->size + 1;

	return new_node;
}


Node *linked_list_insert(List *list, int32_t pos, void *data)
{
	Node *const new_node = linked_list_node_create();

	if (new_node == NULL) {
		return NULL;
	}

	new_node->data = data;

	return linked_list_node_insert(list, pos, new_node);
}


Node *linked_list_append(List *list, void *data)
{
	if (list == NULL) {
		return NULL;
	}

	Node *const new_node = linked_list_node_create();

	if (new_node == NULL) {
		return NULL;
	}

	new_node->data = data;

	Node *const node = linked_list_node_append(list, new_node);

	if (node == NULL) {
		free(new_node);
	}

	return node;
}

