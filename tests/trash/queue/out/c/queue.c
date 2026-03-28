
#include "queue.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

void queue_init(struct queue_queue *q, uint32_t capacity) {
	*q = (struct queue_queue){0};
	q->capacity = capacity;
}

uint32_t queue_capacity(struct queue_queue *q) {
	return q->capacity;
}

uint32_t queue_size(struct queue_queue *q) {
	return q->size;
}

bool queue_isEmpty(struct queue_queue *q) {
	return q->size == 0U;
}

bool queue_isFull(struct queue_queue *q) {
	return q->size == q->capacity;
}
static uint32_t next(uint32_t capacity, uint32_t x);

uint32_t queue_getPutPosition(struct queue_queue *q) {
	const uint32_t pos = q->p;
	q->p = next(q->capacity, q->p);
	if (q->size < q->capacity) {
		q->size = q->size + 1U;
	}
	return pos;
}

uint32_t queue_getGetPosition(struct queue_queue *q) {
	const uint32_t pos = q->g;
	q->g = next(q->capacity, q->g);
	if (q->size > 0U) {
		q->size = q->size - 1U;
	}
	return pos;
}

static uint32_t next(uint32_t capacity, uint32_t x) {
	if (x < capacity - 1U) {
		return x + 1U;
	}
	return 0U;
}

