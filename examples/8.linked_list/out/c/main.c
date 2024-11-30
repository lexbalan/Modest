// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"










static void nat32_list_insert(list_List *list, uint32_t x)
{
	// alloc memory for Nat32 value
	uint32_t *const p_nat32 = (uint32_t *)malloc(sizeof(uint32_t));
	*p_nat32 = x;
	list_append((list_List *)list, p_nat32);
}

static void list_print_forward(list_List *list)
{
	printf("list_print_forward:\n");
	list_Node *pn = (list_Node *)list_first_node_get((list_List *)list);
	while (pn != NULL) {
		uint32_t *const x = (uint32_t *)list_node_data_get((list_Node *)pn);
		printf("v = %u\n", *x);
		pn = (list_Node *)list_node_next_get((list_Node *)pn);
	}
}

static void list_print_backward(list_List *list)
{
	printf("list_print_backward:\n");
	list_Node *pn = (list_Node *)list_last_node_get((list_List *)list);
	while (pn != NULL) {
		uint32_t *const x = (uint32_t *)list_node_data_get((list_Node *)pn);
		printf("v = %u\n", *x);
		pn = (list_Node *)list_node_prev_get((list_Node *)pn);
	}
}

int main()
{
	printf("linked list example\n");

	list_List *const list0 = list_create();

	//list0.size  // access to private field of record

	if (list0 == NULL) {
		printf("error: cannot create list");
		return 1;
	}

	// add some Nat32 values to list
	nat32_list_insert((list_List *)list0, 0);
	nat32_list_insert((list_List *)list0, 10);
	nat32_list_insert((list_List *)list0, 20);
	nat32_list_insert((list_List *)list0, 30);
	nat32_list_insert((list_List *)list0, 40);
	nat32_list_insert((list_List *)list0, 50);
	nat32_list_insert((list_List *)list0, 60);
	nat32_list_insert((list_List *)list0, 70);
	nat32_list_insert((list_List *)list0, 80);
	nat32_list_insert((list_List *)list0, 90);
	nat32_list_insert((list_List *)list0, 100);

	// print list size
	const uint32_t list_size = list_size_get((list_List *)list0);
	printf("linked list size: %u\n", list_size);

	// print list forward
	list_print_forward((list_List *)list0);

	// print list backward
	list_print_backward((list_List *)list0);


	printf("\nlist.node_get(list, n) test\n");

	// test list.node_get
	int32_t i = 0;
	while (i >= -12) {
		list_Node *const node = list_node_get((list_List *)list0, i);

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
		list_Node *const node = list_node_get((list_List *)list0, i);

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
	list_insert((list_List *)list0, 4, p_nat32);

	list_print_forward((list_List *)list0);

	return 0;
}

