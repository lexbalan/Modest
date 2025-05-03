
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "byteRing16.h"


void byteRing16_init(byteRing16_Word8Ring16 *q)
{
	queue_init(&q->queue, /*capacity=*/byteRing16_cap);
	memset(&q->data, 0, sizeof(uint8_t[byteRing16_cap]));
}

uint32_t byteRing16_capacity(byteRing16_Word8Ring16 *q)
{
	return queue_capacity(&q->queue);
}

uint32_t byteRing16_size(byteRing16_Word8Ring16 *q)
{
	return queue_size(&q->queue);
}

bool byteRing16_isFull(byteRing16_Word8Ring16 *q)
{
	return queue_isFull(&q->queue);
}

bool byteRing16_isEmpty(byteRing16_Word8Ring16 *q)
{
	return queue_isEmpty(&q->queue);
}

bool byteRing16_put(byteRing16_Word8Ring16 *q, uint8_t b)
{
	/*if queue.isFull(&q.queue) {
		return false
	}*/

	const uint32_t p = queue_getPutPosition(&q->queue);
	q->data[p] = b;

	return true;
}

bool byteRing16_get(byteRing16_Word8Ring16 *q, uint8_t *b)
{
	if (queue_isEmpty(&q->queue)) {
		return false;
	}

	const uint32_t g = queue_getGetPosition(&q->queue);
	*b = q->data[g];

	return true;
}

