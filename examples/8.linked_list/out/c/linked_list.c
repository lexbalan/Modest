
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <unistd.h>
#include <time.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>


// examples/linked_list/linked_list.cm

#include "./linked_list.h"

struct Node {
    Node *next;
    Node *prev;
    void *link;
};


struct List {
    Node *head;
    Node *tail;
    uint32_t size;
};


List *linked_list_create(void)
{
    List *const list = (List*)malloc(sizeof(List));

    if (list == NULL) {
        return NULL;
    }

    list->head = NULL;
    list->tail = NULL;

    return list;
}

uint32_t linked_list_size_get(List *list)
{
    if (list == NULL) {
        return 0U;
    }

    return list->size;
}

Node *linked_list_first_get(List *list)
{
    if (list == NULL) {
        return NULL;
    }

    return list->head;
}

Node *linked_list_last_get(List *list)
{
    if (list == NULL) {
        return NULL;
    }

    return list->tail;
}

Node *linked_list_node_create(void)
{
    Node *const node = (Node*)malloc(sizeof(Node));

    if (node == NULL) {
        return NULL;
    }

    node->prev = NULL;
    node->next = NULL;
    node->link = NULL;

    return node;
}

Node *linked_list_node_next_get(Node *node)
{
    if (node == NULL) {
        return NULL;
    }

    return node->next;
}

Node *linked_list_node_prev_get(Node *node)
{
    if (node == NULL) {
        return NULL;
    }

    return node->prev;
}

void *linked_list_node_link_get(Node *node)
{
    if (node == NULL) {
        return NULL;
    }

    return node->link;
}

Node *linked_list_insert_node(List *list, Node *new_node)
{
    if (list == NULL || new_node == NULL) {
        return NULL;
    }

    if (list->head == NULL) {
        list->head = new_node;
    }

    if (list->tail != NULL) {
        Node *const old_tail = list->tail;

        old_tail->next = new_node;
        new_node->prev = old_tail;
    }

    list->tail = new_node;
    list->size = list->size + 1U;

    return new_node;
}

Node *linked_list_insert(List *list, void *link)
{
    if (list == NULL) {
        return NULL;
    }

    Node *const new_node = linked_list_node_create();

    if (new_node == NULL) {
        return NULL;
    }

    new_node->link = link;

    Node *const node = linked_list_insert_node(list, new_node);

    if (node == NULL) {
        free((void*)new_node);
    }

    return node;
}

