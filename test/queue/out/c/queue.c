// ./out/c/queue.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "queue.h"




static inline
int32_t queue_next(int32_t x);

static inline
int32_t queue_prev(int32_t x);




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

bool queue_isEmpty(queue_Queue *q)
{
	return q->g == q->p;
}

bool queue_put(queue_Queue *q, uint8_t b)
{
	// пишем в p только если он не налезет на g
	// (в результате сдвига после записи)

	// получим индекс куда p должен прийти
	const int32_t np = queue_next(q->p);

	// И если он будет налазить на t - выходим
	if (np == q->g) {
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

