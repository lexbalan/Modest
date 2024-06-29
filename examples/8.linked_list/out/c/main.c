// examples/8.linked_list/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdlib.h>
#include <stdio.h>
/* forward type declaration */
/* anon recs */




#include "./linked_list.h"


// wrap around linked list for List Nat32
void nat32_list_insert(List *list, uint32_t x)
{
	// alloc memory for Nat32 value
	uint32_t *const p_nat32 = (uint32_t *)malloc(sizeof(uint32_t));
	*p_nat32 = x;
	linked_list_append(list, p_nat32);
}


// show list conent from first item to last
void list_print_forward(List *list)
{
	printf("list_print_forward:\n");
	Node *pn;
	pn = linked_list_first_node_get(list);
	while (pn != NULL) {
		uint32_t *const x = (uint32_t *)linked_list_node_data_get(pn);
		printf("v = %u\n", *x);
		pn = linked_list_node_next_get(pn);
	}
}


// show list conent from last item to first
void list_print_backward(List *list)
{
	printf("list_print_backward:\n");
	Node *pn;
	pn = linked_list_last_node_get(list);
	while (pn != NULL) {
		uint32_t *const x = (uint32_t *)linked_list_node_data_get(pn);
		printf("v = %u\n", *x);
		pn = linked_list_node_prev_get(pn);
	}
}


int main()
{
	printf("linked list example\n");

	List *const list = linked_list_create();

	if (list == NULL) {
		printf("error: cannot create list");
		return 1;
	}

	// add some Nat32 values to list
	nat32_list_insert(list, 0);
	nat32_list_insert(list, 10);
	nat32_list_insert(list, 20);
	nat32_list_insert(list, 30);
	nat32_list_insert(list, 40);
	nat32_list_insert(list, 50);
	nat32_list_insert(list, 60);
	nat32_list_insert(list, 70);
	nat32_list_insert(list, 80);
	nat32_list_insert(list, 90);
	nat32_list_insert(list, 100);

	// print list size
	const uint32_t list_size = linked_list_size_get(list);
	printf("linked list size: %u\n", list_size);

	// print list forward
	list_print_forward(list);

	// print list backward
	list_print_backward(list);


	printf("\nlinked_list_node_get(list, n) test\n");

	// test linked_list_node_get
	int32_t i;
	i = 0;
	while (i >= -12) {
		Node *const node = linked_list_node_get(list, i);

		if (node == NULL) {
			printf("node %i not exist\n", i);
			i = i - 1;
			continue;
		}

		uint32_t *const px = (uint32_t *)linked_list_node_data_get(node);
		printf("list(%i) = %i\n", i, *px);
		i = i - 1;
	}

	printf("-----------------------------------------\n");

	i = 0;
	while (i <= 12) {
		Node *const node = linked_list_node_get(list, i);

		if (node == NULL) {
			printf("node %i not exist\n", i);
			i = i + 1;
			continue;
		}

		uint32_t *const px = (uint32_t *)linked_list_node_data_get(node);
		printf("list(%i) = %i\n", i, *px);
		i = i + 1;
	}

	printf("-----------------------------------------\n");


	uint32_t *const p_nat32 = (uint32_t *)malloc(sizeof(uint32_t));
	*p_nat32 = 1234;
	linked_list_insert(list, 4, p_nat32);

	list_print_forward(list);

	return 0;
}

