
#include "list.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>

struct list_list *list_create(void) {
	struct list_list *const list_list = (struct list_list *)malloc(sizeof(struct list_list));
	if (list_list == NULL) {
		return NULL;
	}
	*list_list = (struct list_list){0};
	return list_list;
}

uint32_t list_size_get(struct list_list *list) {
	if (list == NULL) {
		return 0U;
	}
	return list->size;
}

struct list_node *list_first_node_get(struct list_list *list) {
	if (list == NULL) {
		return NULL;
	}
	return list->head;
}

struct list_node *list_last_node_get(struct list_list *list) {
	if (list == NULL) {
		return NULL;
	}
	return list->tail;
}

struct list_node *list_node_first(struct list_list *list, struct list_node *new_node) {
	if (list == NULL || new_node == NULL) {
		return NULL;
	}
	list->head = new_node;
	list->tail = new_node;
	list->size = list->size + 1U;
	return new_node;
}

struct list_node *list_node_create(void) {
	struct list_node *const list_node = (struct list_node *)malloc(sizeof(struct list_node));
	if (list_node == NULL) {
		return NULL;
	}
	*list_node = (struct list_node){0};
	return list_node;
}

struct list_node *list_node_next_get(struct list_node *node) {
	if (node == NULL) {
		return NULL;
	}
	return node->next;
}

struct list_node *list_node_prev_get(struct list_node *node) {
	if (node == NULL) {
		return NULL;
	}
	return node->prev;
}

void *list_node_data_get(struct list_node *node) {
	if (node == NULL) {
		return NULL;
	}
	return node->data;
}

void list_node_insert_right(struct list_node *left, struct list_node *new_right) {
	struct list_node *const list_old_right = left->next;
	left->next = new_right;
	if (list_old_right != NULL) {
		list_old_right->prev = new_right;
	}
	new_right->next = list_old_right;
	new_right->prev = left;
}

struct list_node *list_node_get(struct list_list *list, int32_t pos) {
	if (list == NULL || list->size == 0U) {
		return NULL;
	}
	printf("node_get(%d)\n", pos);
	struct list_node *node;
	if (pos >= 0) {
		node = list->head;
		const uint32_t list_n = (uint32_t)abs(pos);
		if (list_n > list->size) {
			return NULL;
		}
		uint32_t i = 0U;
		while (i < list_n) {
			node = node->next;
			i = i + 1U;
		}
	} else {
		node = list->tail;
		const uint32_t list_n = (uint32_t)abs(-pos) - 1U;
		if (list_n > list->size) {
			return NULL;
		}
		uint32_t i = 0U;
		while (i < list_n) {
			node = node->prev;
			i = i + 1U;
		}
	}
	return node;
}

struct list_node *list_node_insert(struct list_list *list, int32_t pos, struct list_node *new_node) {
	if (list == NULL || new_node == NULL) {
		return NULL;
	}
	printf("node_insert(%d)\n", pos);
	struct list_node *const list_n = list_node_get(list, pos);
	if (list_n == NULL) {
		return NULL;
	}
	struct list_node *const list_nod = list_node_prev_get(list_n);
	if (list_nod == NULL) {
		return NULL;
	}
	list_node_insert_right(list_nod, new_node);
	list->size = list->size + 1U;
	return new_node;
}

struct list_node *list_node_append(struct list_list *list, struct list_node *new_node) {
	if (list == NULL || new_node == NULL) {
		return NULL;
	}
	if (list->tail == NULL) {
		list->head = new_node;
	} else {
		list_node_insert_right(list->tail, new_node);
	}
	list->tail = new_node;
	list->size = list->size + 1U;
	return new_node;
}

struct list_node *list_insert(struct list_list *list, int32_t pos, void *data) {
	struct list_node *const list_new_node = list_node_create();
	if (list_new_node == NULL) {
		return NULL;
	}
	list_new_node->data = data;
	return list_node_insert(list, pos, list_new_node);
}

struct list_node *list_append(struct list_list *list, void *data) {
	if (list == NULL) {
		return NULL;
	}
	struct list_node *const list_new_node = list_node_create();
	if (list_new_node == NULL) {
		return NULL;
	}
	list_new_node->data = data;
	struct list_node *const list_node = list_node_append(list, list_new_node);
	if (list_node == NULL) {
		free((void *)list_new_node);
		return NULL;
	}
	return list_node;
}

