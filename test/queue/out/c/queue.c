// ./out/c/queue.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "queue.h"



static inline uint32_t next(uint32_t capacity, uint32_t x);




static inline uint32_t next(uint32_t capacity, uint32_t x)
{
	if (x < bufVolume - 1) {
		return x + 1;
	}
	return 0;
}

void queue_init(queue_Queue *q, uint32_t capacity)
{
	*q = (queue_Queue){};
	q->capacity = capacity;
}

uint32_t queue_putPosition(queue_Queue *q)
{
	const uint32_t pos = q->p;
	q->p = next(q->capacity, q->p);
	q->size = q->size + 1;
	return pos;
}

uint32_t queue_getPosition(queue_Queue *q)
{
	const uint32_t pos = q->g;
	q->g = next(q->capacity, q->g);
	q->size = q->size - 1;
	return pos;
}

