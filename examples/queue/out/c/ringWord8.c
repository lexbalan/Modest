
#include "ringWord8.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include "queue.h"

bool ringWord8_init(struct ring_word8_ring_word8 *q, uint8_t *buf, uint32_t capacity) {
	if (buf == NULL || capacity == 0) {
		return false;
	}
	q->data = buf;
	return queue_init(&q->queue, capacity);
}

void ringWord8_deinit(struct ring_word8_ring_word8 *q) {
	uint8_t *const pdata = (uint8_t *)q->data;
	__builtin_bzero(pdata, sizeof(uint8_t) * queue_capacity(&q->queue));
	queue_deinit(&q->queue);
	q->data = NULL;
}

void ringWord8_clear(struct ring_word8_ring_word8 *q) {
	uint8_t *const pdata = (uint8_t *)q->data;
	__builtin_bzero(pdata, sizeof(uint8_t) * queue_capacity(&q->queue));
	queue_clear(&q->queue);
}

uint32_t ringWord8_capacity(struct ring_word8_ring_word8 *q) {
	return queue_capacity(&q->queue);
}

uint32_t ringWord8_size(struct ring_word8_ring_word8 *q) {
	return queue_size(&q->queue);
}

bool ringWord8_isFull(struct ring_word8_ring_word8 *q) {
	return queue_isFull(&q->queue);
}

bool ringWord8_isEmpty(struct ring_word8_ring_word8 *q) {
	return queue_isEmpty(&q->queue);
}

bool ringWord8_put(struct ring_word8_ring_word8 *q, uint8_t b) {
	const uint32_t p = queue_getPutPosition(&q->queue);
	q->data[p] = b;
	return true;
}

bool ringWord8_get(struct ring_word8_ring_word8 *q, uint8_t *b) {
	if (queue_isEmpty(&q->queue)) {
		return false;
	}
	const uint32_t g = queue_getGetPosition(&q->queue);
	*b = q->data[g];
	return true;
}

