
#include "queueWord8.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "queue.h"

void queueWord8_init(struct queue_word8_queue_word8 *q, uint8_t (*buf)[], uint32_t capacity) {
	queue_init(&q->queue, capacity);
	q->data = buf;
}

uint32_t queueWord8_capacity(struct queue_word8_queue_word8 *q) {
	return queue_capacity(&q->queue);
}

uint32_t queueWord8_size(struct queue_word8_queue_word8 *q) {
	return queue_size(&q->queue);
}

bool queueWord8_isFull(struct queue_word8_queue_word8 *q) {
	return queue_isFull(&q->queue);
}

bool queueWord8_isEmpty(struct queue_word8_queue_word8 *q) {
	return queue_isEmpty(&q->queue);
}

bool queueWord8_put(struct queue_word8_queue_word8 *q, uint8_t b) {
	if (queue_isFull(&q->queue)) {
		return false;
	}
	const uint32_t p = queue_getPutPosition(&q->queue);
	(*q->data)[p] = b;
	return true;
}

bool queueWord8_get(struct queue_word8_queue_word8 *q, uint8_t *b) {
	if (queue_isEmpty(&q->queue)) {
		return false;
	}
	const uint32_t g = queue_getGetPosition(&q->queue);
	*b = (*q->data)[g];
	return true;
}

uint32_t queueWord8_read(struct queue_word8_queue_word8 *q, uint8_t (*data)[], uint32_t len) {
	uint32_t n = 0;
	while (n < len) {
		uint8_t x;
		if (!queueWord8_get(q, &x)) {
			break;
		}
		(*data)[n] = x;
		n = n + 1;
	}
	return n;
}

uint32_t queueWord8_write(struct queue_word8_queue_word8 *q, uint8_t (*data)[], uint32_t len) {
	uint32_t n = 0;
	while (n < len) {
		const uint8_t x = (*data)[n];
		if (!queueWord8_put(q, x)) {
			break;
		}
		n = n + 1;
	}
	return n;
}

void queueWord8_clear(struct queue_word8_queue_word8 *q) {
	uint8_t (*const pdata)[queue_capacity(&q->queue)] = (uint8_t (*)[queue_capacity(&q->queue)])q->data;
	__builtin_bzero(pdata, sizeof(uint8_t [queue_capacity(&q->queue)]));
}

