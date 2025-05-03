
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "byteRing.h"


void byteRing_init(byteRing_RingWord8 *q, uint8_t *buf, uint32_t capacity)
{
	queue_init(&q->queue, /*capacity=*/capacity);
	q->data = buf;
}

uint32_t byteRing_capacity(byteRing_RingWord8 *q)
{
	return queue_capacity(&q->queue);
}

uint32_t byteRing_size(byteRing_RingWord8 *q)
{
	return queue_size(&q->queue);
}

bool byteRing_isFull(byteRing_RingWord8 *q)
{
	return queue_isFull(&q->queue);
}

bool byteRing_isEmpty(byteRing_RingWord8 *q)
{
	return queue_isEmpty(&q->queue);
}

bool byteRing_put(byteRing_RingWord8 *q, uint8_t b)
{
	/*
	if queue.isFull(&q.queue) {
		return false
	}
	*/

	const uint32_t p = queue_getPutPosition(&q->queue);
	q->data[p] = b;

	return true;
}

bool byteRing_get(byteRing_RingWord8 *q, uint8_t *b)
{
	if (queue_isEmpty(&q->queue)) {
		return false;
	}

	const uint32_t g = queue_getGetPosition(&q->queue);
	*b = q->data[g];

	return true;
}

