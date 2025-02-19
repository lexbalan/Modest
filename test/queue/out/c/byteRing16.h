
#ifndef BYTERING16_H
#define BYTERING16_H

#include <stdint.h>
#include <stdbool.h>


#include "queue.h"


#define byteRing16_cap  16


struct byteRing16_Word8Ring16 {
	queue_Queue queue;
	uint8_t data[byteRing16_cap];
};
typedef struct byteRing16_Word8Ring16 byteRing16_Word8Ring16;


void byteRing16_init(byteRing16_Word8Ring16 *q);


uint32_t byteRing16_capacity(byteRing16_Word8Ring16 *q);


uint32_t byteRing16_size(byteRing16_Word8Ring16 *q);


bool byteRing16_isFull(byteRing16_Word8Ring16 *q);


bool byteRing16_isEmpty(byteRing16_Word8Ring16 *q);


bool byteRing16_put(byteRing16_Word8Ring16 *q, uint8_t b);


bool byteRing16_get(byteRing16_Word8Ring16 *q, uint8_t *b);

#endif /* BYTERING16_H */
