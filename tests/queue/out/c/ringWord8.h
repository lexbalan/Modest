
#ifndef RINGWORD8_H
#define RINGWORD8_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include "queue.h"


struct ringWord8_RingWord8 {
	queue_Queue queue;
	uint8_t *data;
};
typedef struct ringWord8_RingWord8 ringWord8_RingWord8;
void ringWord8_init(ringWord8_RingWord8 *q, uint8_t *buf, uint32_t capacity);
uint32_t ringWord8_capacity(ringWord8_RingWord8 *q);
uint32_t ringWord8_size(ringWord8_RingWord8 *q);
bool ringWord8_isFull(ringWord8_RingWord8 *q);
bool ringWord8_isEmpty(ringWord8_RingWord8 *q);
bool ringWord8_put(ringWord8_RingWord8 *q, uint8_t b);
bool ringWord8_get(ringWord8_RingWord8 *q, uint8_t *b);

#endif /* RINGWORD8_H */
