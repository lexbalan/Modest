
#include "list.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>



struct list *list_create(void) {
	struct list *const list = (struct list *)malloc(sizeof(struct list));

	if (list == NULL) {
		return NULL;
	}

	*list = (struct list){0};

	return list;
}


uint32_t list_size_get(struct list *list) {
	if (list == NULL) {
		return 0;
	}

	return list->size;
}


struct node *list_first_node_get(struct list *list) {
	if (list == NULL) {
		return NULL;
	}

	return list->head;
}


struct node *list_last_node_get(struct list *list) {
	if (list == NULL) {
		return NULL;
	}

	return list->tail;
}


struct node *list_node_first(struct list *list, struct node *new_node) {
	if (list == NULL || new_node == NULL) {
		return NULL;
	}

	list->head = new_node;
	list->tail = new_node;

	list->size = list->size + 1;

	return new_node;
}


struct node *list_node_create(void) {
	struct node *const node = (struct node *)malloc(sizeof(struct node));

	if (node == NULL) {
		return NULL;
	}

	*node = (struct node){0};

	return node;
}


struct node *list_node_next_get(struct node *node) {
	if (node == NULL) {
		return NULL;
	}

	return node->next;
}


struct node *list_node_prev_get(struct node *node) {
	if (node == NULL) {
		return NULL;
	}

	return node->prev;
}


void *list_node_data_get(struct node *node) {
	if (node == NULL) {
		return NULL;
	}

	return node->data;
}


void list_node_insert_right(struct node *left, struct node *new_right) {
	printf("node_insert_right\n");

	struct node *const old_right = left->next;
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
struct node *list_node_get(struct list *list, int32_t pos) {
	if (list == NULL || list->size == 0) {
		return NULL;
	}

	printf("node_get(%d)\n", pos);
	struct node *node;

	if (pos >= 0) {
		// go forward
		node = list->head;
		const uint32_t n = (uint32_t)abs((int)pos);

		if (n > list->size) {
			return NULL;
		}

		uint32_t i = 0;
		while (i < n) {
			node = node->next;
			i = i + 1;
		}
	} else {
		// go backward
		node = list->tail;
		const uint32_t n = ((uint32_t)abs((int)-pos)) - 1;

		if (n > list->size) {
			return NULL;
		}

		uint32_t i = 0;
		while (i < n) {
			node = node->prev;
			i = i + 1;
		}
	}

	return node;
}


struct node *list_node_insert(struct list *list, int32_t pos, struct node *new_node) {
	if (list == NULL || new_node == NULL) {
		return NULL;
	}

	printf("node_insert(%d)\n", pos);


	struct node *const n = list_node_get(list, pos);

	if (n == NULL) {
		return NULL;
	}

	struct node *const nod = list_node_prev_get(n);

	if (nod == NULL) {
		return NULL;
	}

	list_node_insert_right(nod, new_node);
	list->size = list->size + 1;

	return new_node;
}


struct node *list_node_append(struct list *list, struct node *new_node) {
	if (list == NULL || new_node == NULL) {
		return NULL;
	}

	if (list->tail == NULL) {
		list->head = new_node;
	} else {
		list_node_insert_right(list->tail, new_node);
	}

	list->tail = new_node;

	list->size = list->size + 1;

	return new_node;
}


struct node *list_insert(struct list *list, int32_t pos, void *data) {
	struct node *const new_node = list_node_create();

	if (new_node == NULL) {
		return NULL;
	}

	new_node->data = data;

	return list_node_insert(list, pos, new_node);
}


struct node *list_append(struct list *list, void *data) {
	if (list == NULL) {
		return NULL;
	}

	struct node *const new_node = list_node_create();

	if (new_node == NULL) {
		return NULL;
	}

	new_node->data = data;

	struct node *const node = list_node_append(list, new_node);

	if (node == NULL) {
		free((void *)new_node);
	}

	return node;
}


