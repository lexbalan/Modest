
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

// examples/8.linked_list/main.cm

#include "./linked_list.h"



// wrap around linked list for List Nat64
void nat64_list_insert(List *list, uint64_t x)
{
    // alloc memory for Nat64 value
    uint64_t *const p_nat64 = (uint64_t *const)malloc(sizeof(uint64_t));
    *p_nat64 = x;
    linked_list_insert(list, (void *)p_nat64);
}


// show list conent from first item to last
void list_print_forward(List *list)
{
    printf("list_print_forward:\n");
    Node *pn = linked_list_first_get(list);
    while (pn != NULL) {
        uint32_t *const x = (uint32_t *const)linked_list_node_link_get(pn);
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
        uint32_t *const x = (uint32_t *const)linked_list_node_link_get(pn);
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

    // add some Nat64 values to list
    nat64_list_insert((List *)list, 0);
    nat64_list_insert((List *)list, 10);
    nat64_list_insert((List *)list, 20);
    nat64_list_insert((List *)list, 30);
    nat64_list_insert((List *)list, 40);
    nat64_list_insert((List *)list, 50);
    nat64_list_insert((List *)list, 60);
    nat64_list_insert((List *)list, 70);
    nat64_list_insert((List *)list, 80);
    nat64_list_insert((List *)list, 90);
    nat64_list_insert((List *)list, 100);

    // print list size
    const uint32_t list_size = linked_list_size_get((List *)list);
    printf("linked list size: %d\n", list_size);

    // print list forward
    list_print_forward((List *)list);

    // print list backward
    list_print_backward((List *)list);

    return 0;
}

