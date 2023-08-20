
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>


// examples/linked_list/main.cm

#include "./linked_list.h"


// wrap around linked list for List Nat64

void nat64_list_insert(List *list, uint64_t x)
{
    uint64_t *const p_nat64 = (uint64_t*)malloc(sizeof(uint64_t));
    *p_nat64 = x;
    linked_list_insert(list, (void*)p_nat64);
}


// show list conent from first item to last

void list_print_forward(List *list)
{
    printf("list_print_forward:\n");
    Node *pn = linked_list_first_get(list);
    while (pn != NULL) {
        uint32_t *const x = (uint32_t*)linked_list_node_link_get(pn);
        printf("v = %d\n", *x);
        pn = linked_list_node_next_get(pn);
    }
}


// show list conent from last item to first

void list_print_backward(List *list)
{
    printf("list_print_backward:\n");
    Node *pn = linked_list_last_get(list);
    while (pn != NULL) {
        uint32_t *const x = (uint32_t*)linked_list_node_link_get(pn);
        printf("v = %d\n", *x);
        pn = linked_list_node_prev_get(pn);
    }
}

int main(void)
{
    printf("linked list example\n");
    List *const list = linked_list_create();
    if (list == NULL) {
        printf("error: cannot create list");
        return 1;
    }
    nat64_list_insert(list, 0U);
    nat64_list_insert(list, 10U);
    nat64_list_insert(list, 20U);
    nat64_list_insert(list, 30U);
    nat64_list_insert(list, 40U);
    nat64_list_insert(list, 50U);
    nat64_list_insert(list, 60U);
    nat64_list_insert(list, 70U);
    nat64_list_insert(list, 80U);
    nat64_list_insert(list, 90U);
    nat64_list_insert(list, 100U);
    const uint32_t list_size = linked_list_size_get(list);
    printf("linked list size: %d\n", list_size);
    list_print_forward(list);
    list_print_backward(list);
    return 0;
}

