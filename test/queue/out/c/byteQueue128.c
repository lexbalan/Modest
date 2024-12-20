// ./out/c/byteQueue128.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "byteQueue128.h"



void byteQueue128_init(byteQueue128_Word8Queue128 *q)
{
	queue_init((queue_Queue *)&q->queue, byteQueue128_cap);
	memset(&q->data, 0, sizeof(uint8_t[byteQueue128_cap]));
}


uint32_t byteQueue128_capacity(byteQueue128_Word8Queue128 *q)
{
	return queue_capacity((queue_Queue *)&q->queue);
}


uint32_t byteQueue128_size(byteQueue128_Word8Queue128 *q)
{
	return queue_size((queue_Queue *)&q->queue);
}


bool byteQueue128_isFull(byteQueue128_Word8Queue128 *q)
{
	return queue_isFull((queue_Queue *)&q->queue);
}


bool byteQueue128_isEmpty(byteQueue128_Word8Queue128 *q)
{
	return queue_isEmpty((queue_Queue *)&q->queue);
}


bool byteQueue128_put(byteQueue128_Word8Queue128 *q, uint8_t b)
{
	if (queue_isFull((queue_Queue *)&q->queue)) {
		return false;
	}

	const uint32_t p = queue_getPutPosition((queue_Queue *)&q->queue);
	q->data[p] = b;

	return true;
}


bool byteQueue128_get(byteQueue128_Word8Queue128 *q, uint8_t *b)
{
	if (queue_isEmpty((queue_Queue *)&q->queue)) {
		return false;
	}

	const uint32_t g = queue_getGetPosition((queue_Queue *)&q->queue);
	*b = q->data[g];

	return true;
}

