
#ifndef BYTEQUEUE128_H
#define BYTEQUEUE128_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "queue.h"

typedef struct byteQueue128_ByteQueue128 byteQueue128_ByteQueue128; //
#define capacity  128

struct byteQueue128_ByteQueue128 {
	queue_Queue queue;
	uint8_t data[capacity];
};
void byteQueue128_init(byteQueue128_ByteQueue128 *q);
uint32_t byteQueue128_getSize(byteQueue128_ByteQueue128 *q);
bool byteQueue128_isFull(byteQueue128_ByteQueue128 *q);
bool byteQueue128_isEmpty(byteQueue128_ByteQueue128 *q);
bool byteQueue128_put(byteQueue128_ByteQueue128 *q, uint8_t b);
bool byteQueue128_get(byteQueue128_ByteQueue128 *q, uint8_t *b);

#endif /* BYTEQUEUE128_H */
