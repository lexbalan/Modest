
#ifndef QUEUE_H
#define QUEUE_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>


struct queue_Queue {
	uint32_t capacity;
	uint32_t size;
	uint32_t p;
	uint32_t g;
};
typedef struct queue_Queue queue_Queue;
void queue_init(queue_Queue *q, uint32_t capacity);
uint32_t queue_capacity(queue_Queue *q);
uint32_t queue_size(queue_Queue *q);
bool queue_isEmpty(queue_Queue *q);
bool queue_isFull(queue_Queue *q);
uint32_t queue_getPutPosition(queue_Queue *q);
uint32_t queue_getGetPosition(queue_Queue *q);

#endif /* QUEUE_H */
