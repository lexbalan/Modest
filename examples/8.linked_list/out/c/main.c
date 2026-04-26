
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include "list.h"

static void main_nat32_list_insert(struct list_list *lst, uint32_t x) {
	uint32_t *const main_p_nat32 = (uint32_t *)malloc(sizeof(uint32_t));
	*main_p_nat32 = x;
	list_append(lst, main_p_nat32);
}

static void main_list_print_forward(struct list_list *lst) {
	printf("list_print_forward:\n");
	struct list_node *pn = list_first_node_get(lst);
	while (pn != NULL) {
		uint32_t *const main_x = (uint32_t *)list_node_data_get(pn);
		printf("v = %u\n", *main_x);
		pn = list_node_next_get(pn);
	}
}

static void main_list_print_backward(struct list_list *lst) {
	printf("list_print_backward:\n");
	struct list_node *pn = list_last_node_get(lst);
	while (pn != NULL) {
		uint32_t *const main_x = (uint32_t *)list_node_data_get(pn);
		printf("v = %u\n", *main_x);
		pn = list_node_prev_get(pn);
	}
}

int main(void) {
	printf("linked list example\n");
	struct list_list *const main_list0 = list_create();
	if (main_list0 == NULL) {
		printf("error: cannot create list");
		return 1;
	}
	main_nat32_list_insert(main_list0, 0U);
	main_nat32_list_insert(main_list0, 10U);
	main_nat32_list_insert(main_list0, 20U);
	main_nat32_list_insert(main_list0, 30U);
	main_nat32_list_insert(main_list0, 40U);
	main_nat32_list_insert(main_list0, 50U);
	main_nat32_list_insert(main_list0, 60U);
	main_nat32_list_insert(main_list0, 70U);
	main_nat32_list_insert(main_list0, 80U);
	main_nat32_list_insert(main_list0, 90U);
	main_nat32_list_insert(main_list0, 100U);
	const uint32_t main_list_size = list_size_get(main_list0);
	printf("linked list size: %u\n", main_list_size);
	main_list_print_forward(main_list0);
	main_list_print_backward(main_list0);
	printf("\nlist.node_get(list, n) test\n");
	int32_t i = 0;
	while (i >= -12) {
		struct list_node *const main_node = list_node_get(main_list0, i);
		if (main_node == NULL) {
			printf("node %i not exist\n", i);
			i = i - 1;
			continue;
		}
		uint32_t *const main_px = (uint32_t *)list_node_data_get(main_node);
		printf("list(%i) = %i\n", i, *main_px);
		i = i - 1;
	}
	printf("-----------------------------------------\n");
	i = 0;
	while (i <= 12) {
		struct list_node *const main_node = list_node_get(main_list0, i);
		if (main_node == NULL) {
			printf("node %i not exist\n", i);
			i = i + 1;
			continue;
		}
		uint32_t *const main_px = (uint32_t *)list_node_data_get(main_node);
		printf("list(%i) = %i\n", i, *main_px);
		i = i + 1;
	}
	printf("-----------------------------------------\n");
	uint32_t *const main_p_nat32 = (uint32_t *)malloc(sizeof(uint32_t));
	*main_p_nat32 = 1234U;
	list_insert(main_list0, 4, main_p_nat32);
	main_list_print_forward(main_list0);
	return 0;
}

