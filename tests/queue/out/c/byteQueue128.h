
#ifndef BYTEQUEUE128_H
#define BYTEQUEUE128_H

#include <stdint.h>
#include <stdbool.h>


#include "queue.h"


#define byteQueue128_cap  16


struct byteQueue128_Queue128Word8 {
	queue_Queue queue;
	uint8_t data[byteQueue128_cap];
};
typedef struct byteQueue128_Queue128Word8 byteQueue128_Queue128Word8;


void byteQueue128_init(byteQueue128_Queue128Word8 *q);


uint32_t byteQueue128_capacity(byteQueue128_Queue128Word8 *q);


uint32_t byteQueue128_size(byteQueue128_Queue128Word8 *q);


bool byteQueue128_isFull(byteQueue128_Queue128Word8 *q);


bool byteQueue128_isEmpty(byteQueue128_Queue128Word8 *q);


bool byteQueue128_put(byteQueue128_Queue128Word8 *q, uint8_t b);


bool byteQueue128_get(byteQueue128_Queue128Word8 *q, uint8_t *b);

#endif /* BYTEQUEUE128_H */
