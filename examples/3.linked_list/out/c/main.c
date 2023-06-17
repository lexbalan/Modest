
#include <stdint.h>

#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>

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
	List * const list = malloc(sizeof(List));
	if(list == NULL) {
		return NULL;
	}
	list->head = NULL;
	list->tail = NULL;
	return list;
}

Node *linked_list_node_create() {
	Node * const node = malloc(sizeof(Node));
	if(node == NULL) {
		return NULL;
	}
	node->prev = NULL;
	node->next = NULL;
	node->link = NULL;
	return node;
}

Node *linked_list_insert_node(List *list, Node *new_node) {
	if(list == NULL || new_node == NULL) {
		return NULL;
	}
	if(list->head == NULL) {
		list->head = new_node;
	}
	if(list->tail != NULL) {
		Node * const old_tail = list->tail;
		old_tail->next = new_node;
		new_node->prev = old_tail;
	}
	list->tail = new_node;
	list->size = list->size + 1;
	return new_node;
}

Node *linked_list_insert(List *list, void *link) {
	if(list == NULL || link == NULL) {
		return NULL;
	}
	Node * const new_node = linked_list_node_create();
	if(new_node == NULL) {
		return NULL;
	}
	new_node->link = link;
	Node * const node = linked_list_insert_node(list, new_node);
	if(node == NULL) {
		free(new_node);
	}
	return node;
}

void nat64_list_insert(List *list, uint64_t x) {
	uint64_t * const p_nat64 = malloc(sizeof(uint64_t));
	*p_nat64 = x;
	linked_list_insert(list, p_nat64);
}

void list_print_forward(List *list) {
	printf("list_print_forward:\n");
	Node *pn = list->head;
	while(pn != NULL) {
		uint32_t * const x = pn->link;
		printf("v = %d\n", *x);
		pn = pn->next;
	}
}

void list_print_backward(List *list) {
	printf("list_print_backward:\n");
	Node *pn = list->tail;
	while(pn != NULL) {
		uint32_t * const x = pn->link;
		printf("v = %d\n", *x);
		pn = pn->prev;
	}
}

int32_t main() {
	printf("linked list example\n");
	List * const list = linked_list_create();
	if(list == NULL) {
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

