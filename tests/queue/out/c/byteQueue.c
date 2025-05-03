
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "byteQueue.h"


void byteQueue_init(byteQueue_QueueWord8 *q, uint8_t *buf, uint32_t capacity)
{
	queue_init(&q->queue, /*capacity=*/capacity);
	q->data = buf;
}

uint32_t byteQueue_capacity(byteQueue_QueueWord8 *q)
{
	return queue_capacity(&q->queue);
}

uint32_t byteQueue_size(byteQueue_QueueWord8 *q)
{
	return queue_size(&q->queue);
}

bool byteQueue_isFull(byteQueue_QueueWord8 *q)
{
	return queue_isFull(&q->queue);
}

bool byteQueue_isEmpty(byteQueue_QueueWord8 *q)
{
	return queue_isEmpty(&q->queue);
}

bool byteQueue_put(byteQueue_QueueWord8 *q, uint8_t b)
{
	if (queue_isFull(&q->queue)) {
		return false;
	}

	const uint32_t p = queue_getPutPosition(&q->queue);
	q->data[p] = b;

	return true;
}

bool byteQueue_get(byteQueue_QueueWord8 *q, uint8_t *b)
{
	if (queue_isEmpty(&q->queue)) {
		return false;
	}

	const uint32_t g = queue_getGetPosition(&q->queue);
	*b = q->data[g];

	return true;
}

