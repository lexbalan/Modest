
#ifndef QUEUE_H
#define QUEUE_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




typedef struct queue_Queue queue_Queue; //



struct queue_Queue {
	uint32_t capacity;
	uint32_t size;
	uint32_t p;
	uint32_t g;
};
void queue_init(queue_Queue *q, uint32_t capacity);
static inline uint32_t queue_capacity(queue_Queue *q)
{
	return q->capacity;
}
static inline uint32_t queue_size(queue_Queue *q)
{
	return q->size;
}
static inline bool queue_isEmpty(queue_Queue *q)
{
	return q->size == 0;
}
static inline bool queue_isFull(queue_Queue *q)
{
	return q->size == q->capacity;
}
uint32_t queue_putPosition(queue_Queue *q);
uint32_t queue_getPosition(queue_Queue *q);

#endif /* QUEUE_H */
