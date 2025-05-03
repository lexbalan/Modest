
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "byteQueue128.h"


void byteQueue128_init(byteQueue128_Queue128Word8 *q)
{
	queue_init(&q->queue, /*capacity=*/byteQueue128_cap);
	memset(&q->data, 0, sizeof(uint8_t[byteQueue128_cap]));
}

uint32_t byteQueue128_capacity(byteQueue128_Queue128Word8 *q)
{
	return queue_capacity(&q->queue);
}

uint32_t byteQueue128_size(byteQueue128_Queue128Word8 *q)
{
	return queue_size(&q->queue);
}

bool byteQueue128_isFull(byteQueue128_Queue128Word8 *q)
{
	return queue_isFull(&q->queue);
}

bool byteQueue128_isEmpty(byteQueue128_Queue128Word8 *q)
{
	return queue_isEmpty(&q->queue);
}

bool byteQueue128_put(byteQueue128_Queue128Word8 *q, uint8_t b)
{
	if (queue_isFull(&q->queue)) {
		return false;
	}

	const uint32_t p = queue_getPutPosition(&q->queue);
	q->data[p] = b;

	return true;
}

bool byteQueue128_get(byteQueue128_Queue128Word8 *q, uint8_t *b)
{
	if (queue_isEmpty(&q->queue)) {
		return false;
	}

	const uint32_t g = queue_getGetPosition(&q->queue);
	*b = q->data[g];

	return true;
}

