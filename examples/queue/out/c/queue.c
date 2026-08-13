
#include "queue.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>


bool queue_init(struct queue_queue *q, uint32_t capacity) {
	if (capacity == 0) {
		return false;
	}
	queue_deinit(q);
	q->capacity = capacity;
	return true;
}

void queue_deinit(struct queue_queue *q) {
	*q = (struct queue_queue){0};
}

void queue_clear(struct queue_queue *q) {
	*q = (struct queue_queue){.capacity = q->capacity};
}

uint32_t queue_capacity(struct queue_queue *q) {
	return q->capacity;
}

uint32_t queue_size(struct queue_queue *q) {
	return q->size;
}

bool queue_isEmpty(struct queue_queue *q) {
	return q->size == 0;
}

bool queue_isFull(struct queue_queue *q) {
	return q->size == q->capacity;
}

static uint32_t next(uint32_t capacity, uint32_t x);

uint32_t queue_getPutPosition(struct queue_queue *q) {
	const uint32_t pos = q->p;
	q->p = next(q->capacity, q->p);
	if (q->size < q->capacity) {
		++q->size;
	}
	return pos;
}

uint32_t queue_getGetPosition(struct queue_queue *q) {
	const uint32_t pos = q->g;
	q->g = next(q->capacity, q->g);
	if (q->size > 0) {
		--q->size;
	}
	return pos;
}

static uint32_t next(uint32_t capacity, uint32_t x) {
	if (x + 1 < capacity) {
		return x + 1;
	}
	return 0;
}

