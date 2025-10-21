// queueWord8
// queue implementation example

#ifndef QUEUEWORD8_H
#define QUEUEWORD8_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include "queue.h"


struct queueWord8_QueueWord8 {
	queue_Queue queue;
	uint8_t *data;
};
typedef struct queueWord8_QueueWord8 queueWord8_QueueWord8;
void queueWord8_init(queueWord8_QueueWord8 *q, uint8_t *buf, uint32_t capacity);
uint32_t queueWord8_capacity(queueWord8_QueueWord8 *q);
uint32_t queueWord8_size(queueWord8_QueueWord8 *q);
bool queueWord8_isFull(queueWord8_QueueWord8 *q);
bool queueWord8_isEmpty(queueWord8_QueueWord8 *q);
bool queueWord8_put(queueWord8_QueueWord8 *q, uint8_t b);
bool queueWord8_get(queueWord8_QueueWord8 *q, uint8_t *b);
uint32_t queueWord8_read(queueWord8_QueueWord8 *q, uint8_t *data, uint32_t len);
uint32_t queueWord8_write(queueWord8_QueueWord8 *q, uint8_t *data, uint32_t len);
void queueWord8_clear(queueWord8_QueueWord8 *q);

#endif /* QUEUEWORD8_H */
