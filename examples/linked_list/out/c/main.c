
#include <stdint.h>

#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>

// type declaration Node
struct Node;
typedef struct Node Node;


struct Node {
	Node *next;
	Node *prev;
	void *link;
};


typedef struct {
	Node *head;
	Node *tail;
	uint32_t size;
} List;

List *linked_list_create() {
	List *list = (List*)(malloc((uint32_t)(sizeof(List))));
	if ((void*)list == NULL) {
		return (List*)(NULL);
	}
	list->head = (Node*)(NULL);
	list->tail = (Node*)(NULL);
	return list;
}

Node *linked_list_node_create() {
	Node *node = (Node*)(malloc((uint32_t)(sizeof(Node))));
	if ((void*)node == NULL) {
		return (Node*)(NULL);
	}
	node->prev = (Node*)(NULL);
	node->next = (Node*)(NULL);
	node->link = NULL;
	return node;
}

Node *linked_list_insert_node(List *list, Node *new_node) {
	if ((void*)list == NULL || (void*)new_node == NULL) {
		return (Node*)(NULL);
	}
	if ((void*)(list->head) == NULL) {
		list->head = new_node;
	}
	if ((void*)(list->tail) != NULL) {
		Node *old_tail = list->tail;
		old_tail->next = new_node;
		new_node->prev = old_tail;
	}
	list->tail = new_node;
	list->size = list->size + 1;
	return new_node;
}

Node *linked_list_insert(List *list, void *link) {
	if ((void*)list == NULL || link == NULL) {
		return (Node*)(NULL);
	}
	Node *new_node = linked_list_node_create();
	if ((void*)new_node == NULL) {
		return (Node*)(NULL);
	}
	new_node->link = link;
	Node *node = linked_list_insert_node(list, new_node);
	if ((void*)node == NULL) {
		free((void*)new_node);
	}
	return node;
}

void nat64_list_insert(List *list, uint64_t x) {
	uint64_t *p_nat64 = (uint64_t*)(malloc((uint32_t)(sizeof(uint64_t))));
	*p_nat64 = x;
	linked_list_insert(list, (void*)p_nat64);
}

void list_print_forward(List *list) {
	printf("list_print_forward:\n");
	Node *pn = list->head;
	while ((void*)pn != NULL) {
		uint32_t *x = (uint32_t*)(pn->link);
		printf("v = %d\n", *x);
		pn = pn->next;
	}
}

void list_print_backward(List *list) {
	printf("list_print_backward:\n");
	Node *pn = list->tail;
	while ((void*)pn != NULL) {
		uint32_t *x = (uint32_t*)(pn->link);
		printf("v = %d\n", *x);
		pn = pn->prev;
	}
}

int main() {
	printf("linked list example\n");
	List *list = linked_list_create();
	if ((void*)list == NULL) {
		printf("error: cannot create list");
		return 1;
	}
	nat64_list_insert(list, 0);
	nat64_list_insert(list, 10);
	nat64_list_insert(list, 20);
	nat64_list_insert(list, 30);
	nat64_list_insert(list, 40);
	nat64_list_insert(list, 50);
	nat64_list_insert(list, 60);
	nat64_list_insert(list, 70);
	nat64_list_insert(list, 80);
	nat64_list_insert(list, 90);
	nat64_list_insert(list, 100);
	printf("linked list size: %d\n", list->size);
	list_print_forward(list);
	list_print_backward(list);
	return 0;
}

