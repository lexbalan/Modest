
#ifndef BYTERING_H
#define BYTERING_H

#include <stdint.h>
#include <stdbool.h>

#include "queue.h"

struct byteRing_RingWord8 {
	queue_Queue queue;
	uint8_t *data;
};
typedef struct byteRing_RingWord8 byteRing_RingWord8;

void byteRing_init(byteRing_RingWord8 *q, uint8_t *buf, uint32_t capacity);

uint32_t byteRing_capacity(byteRing_RingWord8 *q);

uint32_t byteRing_size(byteRing_RingWord8 *q);

bool byteRing_isFull(byteRing_RingWord8 *q);

bool byteRing_isEmpty(byteRing_RingWord8 *q);

bool byteRing_put(byteRing_RingWord8 *q, uint8_t b);

bool byteRing_get(byteRing_RingWord8 *q, uint8_t *b);

#endif /* BYTERING_H */
