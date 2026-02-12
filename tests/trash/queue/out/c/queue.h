
#ifndef QUEUE_H
#define QUEUE_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>



struct queue_queue {
	uint32_t capacity;
	uint32_t size;
	uint32_t p;
	uint32_t g;
};
void queue_init(struct queue_queue *q, uint32_t capacity);
uint32_t queue_capacity(struct queue_queue *q);
uint32_t queue_size(struct queue_queue *q);
bool queue_isEmpty(struct queue_queue *q);
bool queue_isFull(struct queue_queue *q);
uint32_t queue_getPutPosition(struct queue_queue *q);
uint32_t queue_getGetPosition(struct queue_queue *q);

#endif /* QUEUE_H */
