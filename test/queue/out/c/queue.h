
#ifndef QUEUE_H
#define QUEUE_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "console.h"



typedef struct queue_Queue queue_Queue; //
#define bufVolume  4

struct queue_Queue {
	uint8_t data[bufVolume];
	int32_t p;
	int32_t g;
	uint32_t size;
};
void queue_init(queue_Queue *q);
bool queue_isEmpty(queue_Queue *q);
bool queue_isFull(queue_Queue *q);
bool queue_put(queue_Queue *q, uint8_t b);
uint8_t queue_get(queue_Queue *q);

#endif /* QUEUE_H */
