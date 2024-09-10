// ./out/c/queue.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "queue.h"



static inline int32_t next(int32_t x);
static inline int32_t prev(int32_t x);



static inline int32_t next(int32_t x)
{
	if (x < bufSize - 1) {
		return x + 1;
	}
	return 0;
}

static inline int32_t prev(int32_t x)
{
	if (x > 1) {
		return x - 1;
	}
	return bufSize;
}

void queue_init(queue_Queue *q)
{
	memset(&q->data, 0, sizeof(uint8_t[bufSize]));
	q->p = 0;
	q->g = 0;
}

bool queue_isEmpty(queue_Queue *q)
{
	const bool x = q->g == q->p;
	return x;
}

bool queue_put(queue_Queue *q, uint8_t b)
{
	// пишем в p только если он не налезет на g
	// (в результате сдвига после записи)

	// получим индекс куда p должен прийти
	const int32_t np = next(q->p);

	// И если он будет налазить на t - выходим
	if (np == q->g) {
		return false;
	}

	//printf("put %d to %d\n", Int32 b, q.p)
	q->data[q->p] = b;
	q->p = np;

	return true;
}

uint8_t queue_get(queue_Queue *q)
{
	const int32_t ng = next(q->g);
	const uint8_t x = q->data[q->g];
	q->g = ng;
	return x;
}

