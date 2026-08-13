
#if !defined(RING_WORD8_H)
#define RING_WORD8_H
#include "queue.h"
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
struct ring_word8_ring_word8 {
	struct queue_queue queue;
	uint8_t *data;
};
bool ringWord8_init(struct ring_word8_ring_word8 *q, uint8_t *buf, uint32_t capacity);
void ringWord8_deinit(struct ring_word8_ring_word8 *q);
void ringWord8_clear(struct ring_word8_ring_word8 *q);
uint32_t ringWord8_capacity(struct ring_word8_ring_word8 *q);
uint32_t ringWord8_size(struct ring_word8_ring_word8 *q);
bool ringWord8_isFull(struct ring_word8_ring_word8 *q);
bool ringWord8_isEmpty(struct ring_word8_ring_word8 *q);
bool ringWord8_put(struct ring_word8_ring_word8 *q, uint8_t b);
bool ringWord8_get(struct ring_word8_ring_word8 *q, uint8_t *b);
#endif

