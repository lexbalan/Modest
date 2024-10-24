// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



void nat32_list_insert(list_List *list, uint32_t x);
void list_print_forward(list_List *list);
void list_print_backward(list_List *list);







void nat32_list_insert(list_List *list, uint32_t x)
{
	// alloc memory for Nat32 value
	uint32_t *const p_nat32 = (uint32_t *)malloc(sizeof(uint32_t));
	*p_nat32 = x;
	list_append((list_List *)list, p_nat32);
}

void list_print_forward(list_List *list)
{
	printf("list_print_forward:\n");
	list_Node *pn;
	pn = list_first_node_get((list_List *)list);
	while (pn != NULL) {
		uint32_t *const x = (uint32_t *)list_node_data_get((list_Node *)pn);
		printf("v = %u\n", *x);
		pn = (list_Node *)list_node_next_get((list_Node *)pn);
	}
}

void list_print_backward(list_List *list)
{
	printf("list_print_backward:\n");
	list_Node *pn;
	pn = list_last_node_get((list_List *)list);
	while (pn != NULL) {
		uint32_t *const x = (uint32_t *)list_node_data_get((list_Node *)pn);
		printf("v = %u\n", *x);
		pn = (list_Node *)list_node_prev_get((list_Node *)pn);
	}
}

int main()
{
	printf("linked list example\n");

	list_List *const list = list_create();

	if (list == NULL) {
		printf("error: cannot create list");
		return 1;
	}

	// add some Nat32 values to list
	nat32_list_insert((list_List *)list, 0);
	nat32_list_insert((list_List *)list, 10);
	nat32_list_insert((list_List *)list, 20);
	nat32_list_insert((list_List *)list, 30);
	nat32_list_insert((list_List *)list, 40);
	nat32_list_insert((list_List *)list, 50);
	nat32_list_insert((list_List *)list, 60);
	nat32_list_insert((list_List *)list, 70);
	nat32_list_insert((list_List *)list, 80);
	nat32_list_insert((list_List *)list, 90);
	nat32_list_insert((list_List *)list, 100);

	// print list size
	const uint32_t list_size = list_size_get((list_List *)list);
	printf("linked list size: %u\n", list_size);

	// print list forward
	list_print_forward((list_List *)list);

	// print list backward
	list_print_backward((list_List *)list);


	printf("\nlist.node_get(list, n) test\n");

	// test list.node_get
	int32_t i;
	i = 0;
	while (i >= -12) {
		list_Node *const node = list_node_get((list_List *)list, i);

		if (node == NULL) {
			printf("node %i not exist\n", i);
			i = i - 1;
			continue;
		}

		uint32_t *const px = (uint32_t *)list_node_data_get((list_Node *)node);
		printf("list(%i) = %i\n", i, *px);
		i = i - 1;
	}

	printf("-----------------------------------------\n");

	i = 0;
	while (i <= 12) {
		list_Node *const node = list_node_get((list_List *)list, i);

		if (node == NULL) {
			printf("node %i not exist\n", i);
			i = i + 1;
			continue;
		}

		uint32_t *const px = (uint32_t *)list_node_data_get((list_Node *)node);
		printf("list(%i) = %i\n", i, *px);
		i = i + 1;
	}

	printf("-----------------------------------------\n");


	uint32_t *const p_nat32 = (uint32_t *)malloc(sizeof(uint32_t));
	*p_nat32 = 1234;
	list_insert((list_List *)list, 4, p_nat32);

	list_print_forward((list_List *)list);

	return 0;
}

