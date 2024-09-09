// ./out/c/queue.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "queue.h"



int32_t queue_next(int32_t x);
int32_t queue_prev(int32_t x);





bool queue_isEmpty(queue_Queue *q)
{
	return q->g == q->p;
}

bool queue_put(queue_Queue *q, uint8_t b)
{
	// пишем в p
	// !если он не налезет на g в результате

	// получим индекс куда хвост должен прийти
	const int32_t np = queue_next(q->p);

	// И если он будет налазить на голову - выходим
	if (np == q->g) {
		// Если добавить то хвост наедет на голову, так нельзя
		return false;
	}

	printf("put %d to %d\n", (int32_t)b, q->p);
	q->data[q->p] = b;
	q->p = np;
	return true;
}

uint8_t queue_get(queue_Queue *q)
{
	const int32_t ng = queue_next(q->g);
	const uint8_t x = q->data[q->g];
	q->g = ng;
	return x;
}

