
#include "ringWord8.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "queue.h"



void ringWord8_init(ringWord8_RingWord8 *q, uint8_t(*buf)[], uint32_t capacity) {
	queue_init(&q->queue, capacity);
	q->data = buf;
}


uint32_t ringWord8_capacity(ringWord8_RingWord8 *q) {
	return queue_capacity(&q->queue);
}


uint32_t ringWord8_size(ringWord8_RingWord8 *q) {
	return queue_size(&q->queue);
}


bool ringWord8_isFull(ringWord8_RingWord8 *q) {
	return queue_isFull(&q->queue);
}


bool ringWord8_isEmpty(ringWord8_RingWord8 *q) {
	return queue_isEmpty(&q->queue);
}


bool ringWord8_put(ringWord8_RingWord8 *q, uint8_t b) {
	/*
	if queue.isFull(&q.queue) {
		return false
	}
	*/

	const uint32_t p = queue_getPutPosition(&q->queue);
	(*q->data)[p] = b;

	return true;
}


bool ringWord8_get(ringWord8_RingWord8 *q, uint8_t *b) {
	if (queue_isEmpty(&q->queue)) {
		return false;
	}

	const uint32_t g = queue_getGetPosition(&q->queue);
	*b = (*q->data)[g];

	return true;
}


