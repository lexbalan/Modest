// ./out/c/queue.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "queue.h"



static inline int32_t next(int32_t x);




static inline int32_t next(int32_t x)
{
	if (x < bufVolume - 1) {
		return x + 1;
	}
	return 0;
}

void queue_init(queue_Queue *q)
{
	memset(&q->data, 0, sizeof(uint8_t[bufVolume]));
	q->size = 0;
	q->p = 0;
	q->g = 0;
}

bool queue_isEmpty(queue_Queue *q)
{
	return q->size == 0;
}

bool queue_isFull(queue_Queue *q)
{
	return q->size == bufVolume;
}

bool queue_put(queue_Queue *q, uint8_t b)
{
	if (queue_isFull((queue_Queue *)q)) {
		return false;
	}

	//printf("put %d to %d\n", Int32 b, q.p)
	q->data[q->p] = b;
	q->p = next(q->p);
	q->size = q->size + 1;

	return true;
}

uint8_t queue_get(queue_Queue *q)
{
	if (queue_isEmpty((queue_Queue *)q)) {
		return 0;
	}

	const uint8_t x = q->data[q->g];
	q->g = next(q->g);
	q->size = q->size - 1;
	return x;
}

