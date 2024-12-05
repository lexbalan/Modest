
#ifndef BYTEQUEUE128_H
#define BYTEQUEUE128_H

#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include "queue.h"



struct byteQueue128_Word8Queue128 {
	queue_Queue queue;
	uint8_t data[cap];
};
typedef struct byteQueue128_Word8Queue128 byteQueue128_Word8Queue128;
void byteQueue128_init(byteQueue128_Word8Queue128 *q);
uint32_t byteQueue128_capacity(byteQueue128_Word8Queue128 *q);
uint32_t byteQueue128_size(byteQueue128_Word8Queue128 *q);
bool byteQueue128_isFull(byteQueue128_Word8Queue128 *q);
bool byteQueue128_isEmpty(byteQueue128_Word8Queue128 *q);
bool byteQueue128_put(byteQueue128_Word8Queue128 *q, uint8_t b);
bool byteQueue128_get(byteQueue128_Word8Queue128 *q, uint8_t *b);

#endif /* BYTEQUEUE128_H */
