
#ifndef QUEUEWORD8_H
#define QUEUEWORD8_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include "queue.h"


struct queue_word8 {
	struct queue queue;
	uint8_t (*data)[];
};
void queueWord8_init(struct queue_word8 *q, uint8_t (*buf)[], uint32_t capacity);
uint32_t queueWord8_capacity(struct queue_word8 *q);
uint32_t queueWord8_size(struct queue_word8 *q);
bool queueWord8_isFull(struct queue_word8 *q);
bool queueWord8_isEmpty(struct queue_word8 *q);
bool queueWord8_put(struct queue_word8 *q, uint8_t b);
bool queueWord8_get(struct queue_word8 *q, uint8_t *b);
uint32_t queueWord8_read(struct queue_word8 *q, uint8_t (*data)[], uint32_t len);
uint32_t queueWord8_write(struct queue_word8 *q, uint8_t (*data)[], uint32_t len);
void queueWord8_clear(struct queue_word8 *q);

#endif /* QUEUEWORD8_H */
