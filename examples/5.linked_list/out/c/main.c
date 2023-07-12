
#include <stdint.h>
#include <string.h>

#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdio.h>
#include "./linked_list.h"

void nat64_list_insert(List *list, uint64_t x) {
	uint64_t * const p_nat64 = malloc(sizeof(uint64_t));
	*p_nat64 = x;
	linked_list_insert(list, p_nat64);
}

void list_print_forward(List *list) {
	printf("list_print_forward:\n");
	Node *pn = linked_list_first_get(list);
	while(pn != NULL) {
		uint32_t * const x = linked_list_node_link_get(pn);
		printf("v = %d\n", *x);
		pn = linked_list_node_next_get(pn);
	}
}

void list_print_backward(List *list) {
	printf("list_print_backward:\n");
	Node *pn = linked_list_last_get(list);
	while(pn != NULL) {
		uint32_t * const x = linked_list_node_link_get(pn);
		printf("v = %d\n", *x);
		pn = linked_list_node_prev_get(pn);
	}
}

int main() {
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
	const uint32_t list_size = linked_list_size_get(list);
	printf("linked list size: %d\n", list_size);
	list_print_forward(list);
	list_print_backward(list);
	return 0;
}

