
#ifndef QUEUE_H
#define QUEUE_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "console.h"
#include "inttypes.h"

typedef struct queue_Queue queue_Queue; //
#define bufSize  8

struct queue_Queue {
	uint8_t data[bufSize];
	int32_t head;
	int32_t tail;
};
bool queue_isEmpty(queue_Queue *q);
bool queue_put(queue_Queue *q, uint8_t b);
uint8_t queue_get(queue_Queue *q);

#endif /* QUEUE_H */
