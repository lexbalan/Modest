// examples/8.linked_list/linked_list.cm

#include "list.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>



list_List *list_create() {
	list_List *const list = (list_List *)malloc(sizeof(list_List));

	if (list == NULL) {
		return NULL;
	}

	*list = (list_List){};

	return list;
}


uint32_t list_size_get(list_List *list) {
	if (list == NULL) {
		return 0;
	}

	return list->size;
}


list_Node *list_first_node_get(list_List *list) {
	if (list == NULL) {
		return NULL;
	}

	return list->head;
}


list_Node *list_last_node_get(list_List *list) {
	if (list == NULL) {
		return NULL;
	}

	return list->tail;
}


list_Node *list_node_first(list_List *list, list_Node *new_node) {
	if (list == NULL || new_node == NULL) {
		return NULL;
	}

	list->head = new_node;
	list->tail = new_node;

	list->size = list->size + 1;

	return new_node;
}


list_Node *list_node_create() {
	list_Node *const node = (list_Node *)malloc(sizeof(list_Node));

	if (node == NULL) {
		return NULL;
	}

	*node = (list_Node){};

	return node;
}


list_Node *list_node_next_get(list_Node *node) {
	if (node == NULL) {
		return NULL;
	}

	return node->next;
}


list_Node *list_node_prev_get(list_Node *node) {
	if (node == NULL) {
		return NULL;
	}

	return node->prev;
}


void *list_node_data_get(list_Node *node) {
	if (node == NULL) {
		return NULL;
	}

	return node->data;
}


void list_node_insert_right(list_Node *left, list_Node *new_right) {
	printf("node_insert_right\n");

	list_Node *const old_right = left->next;
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
list_Node *list_node_get(list_List *list, int32_t pos) {
	if (list == NULL || list->size == 0) {
		return NULL;
	}

	printf("node_get(%d)\n", pos);
	list_Node *node;

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


list_Node *list_node_insert(list_List *list, int32_t pos, list_Node *new_node) {
	if (list == NULL || new_node == NULL) {
		return NULL;
	}

	printf("node_insert(%d)\n", pos);


	list_Node *const n = list_node_get(list, pos);

	if (n == NULL) {
		return NULL;
	}

	list_Node *const nod = list_node_prev_get(n);

	if (nod == NULL) {
		return NULL;
	}

	list_node_insert_right(nod, new_node);
	list->size = list->size + 1;

	return new_node;
}


list_Node *list_node_append(list_List *list, list_Node *new_node) {
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


list_Node *list_insert(list_List *list, int32_t pos, void *data) {
	list_Node *const new_node = list_node_create();

	if (new_node == NULL) {
		return NULL;
	}

	new_node->data = data;

	return list_node_insert(list, pos, new_node);
}


list_Node *list_append(list_List *list, void *data) {
	if (list == NULL) {
		return NULL;
	}

	list_Node *const new_node = list_node_create();

	if (new_node == NULL) {
		return NULL;
	}

	new_node->data = data;

	list_Node *const node = list_node_append(list, new_node);

	if (node == NULL) {
		free(new_node);
	}

	return node;
}


