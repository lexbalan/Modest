
#ifndef QUEUE_H
#define QUEUE_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "console.h"
#include "inttypes.h"

typedef struct queue_Queue queue_Queue; //
#define bufSize  4

struct queue_Queue {
	uint8_t data[bufSize];
	int32_t p;
	int32_t g;
};
bool queue_isEmpty(queue_Queue *q);
bool queue_put(queue_Queue *q, uint8_t b);
uint8_t queue_get(queue_Queue *q);

static inline
int32_t queue_next(int32_t x)
{
	if (x < bufSize - 1) {
		return x + 1;
	}
	return 0;
}

static inline
int32_t queue_prev(int32_t x)
{
	if (x > 1) {
		return x - 1;
	}
	return bufSize;
}

#endif /* QUEUE_H */
