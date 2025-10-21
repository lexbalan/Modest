// queueWord8
// queue implementation example

#include "queueWord8.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>



void queueWord8_init(queueWord8_QueueWord8 *q, uint8_t *buf, uint32_t capacity) {
	queue_init(&q->queue, capacity);
	q->data = buf;
}


uint32_t queueWord8_capacity(queueWord8_QueueWord8 *q) {
	return queue_capacity(&q->queue);
}


uint32_t queueWord8_size(queueWord8_QueueWord8 *q) {
	return queue_size(&q->queue);
}


bool queueWord8_isFull(queueWord8_QueueWord8 *q) {
	return queue_isFull(&q->queue);
}


bool queueWord8_isEmpty(queueWord8_QueueWord8 *q) {
	return queue_isEmpty(&q->queue);
}


bool queueWord8_put(queueWord8_QueueWord8 *q, uint8_t b) {
	if (queue_isFull(&q->queue)) {
		return false;
	}

	const uint32_t p = queue_getPutPosition(&q->queue);
	q->data[p] = b;

	return true;
}


bool queueWord8_get(queueWord8_QueueWord8 *q, uint8_t *b) {
	if (queue_isEmpty(&q->queue)) {
		return false;
	}

	const uint32_t g = queue_getGetPosition(&q->queue);
	*b = q->data[g];

	return true;
}


uint32_t queueWord8_read(queueWord8_QueueWord8 *q, uint8_t *data, uint32_t len) {
	uint32_t n = 0;
	while (n < len) {
		uint8_t x;
		if (!queueWord8_get(q, &x)) {
			break;
		}
		data[n] = x;
		n = n + 1;
	}
	return n;
}


uint32_t queueWord8_write(queueWord8_QueueWord8 *q, uint8_t *data, uint32_t len) {
	uint32_t n = 0;
	while (n < len) {
		const uint8_t x = data[n];
		if (!queueWord8_put(q, x)) {
			break;
		}
		n = n + 1;
	}
	return n;
}


void queueWord8_clear(queueWord8_QueueWord8 *q) {
	uint8_t *const pdata = (uint8_t *)(uint8_t *)q->data;
	memset(pdata, 0, sizeof(uint8_t[queue_capacity(&q->queue)]));
}


