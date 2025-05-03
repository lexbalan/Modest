
#ifndef BYTEQUEUE_H
#define BYTEQUEUE_H

#include <stdint.h>
#include <stdbool.h>

#include "queue.h"

struct byteQueue_QueueWord8 {
	queue_Queue queue;
	uint8_t *data;
};
typedef struct byteQueue_QueueWord8 byteQueue_QueueWord8;

void byteQueue_init(byteQueue_QueueWord8 *q, uint8_t *buf, uint32_t capacity);

uint32_t byteQueue_capacity(byteQueue_QueueWord8 *q);

uint32_t byteQueue_size(byteQueue_QueueWord8 *q);

bool byteQueue_isFull(byteQueue_QueueWord8 *q);

bool byteQueue_isEmpty(byteQueue_QueueWord8 *q);

bool byteQueue_put(byteQueue_QueueWord8 *q, uint8_t b);

bool byteQueue_get(byteQueue_QueueWord8 *q, uint8_t *b);

#endif /* BYTEQUEUE_H */
