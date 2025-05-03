
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <stdio.h>

#include "main.h"


static byteQueue_QueueWord8 bq0;
static byteRing_RingWord8 br0;

static int32_t ii;
static void padd(int n)
{
	int32_t i = 0;
	while (i < n) {
		if (byteQueue_isFull(&bq0)) {
			printf("<queue is full>\n");
			break;
		}

		printf("bq.put(%d)\n", ii);
		byteQueue_put(&bq0, (uint8_t)ii);
		i = i + 1;
		ii = ii + 1;
	}
}
static void fetch(int n)
{
	int32_t i = 0;
	while (i < n) {
		if (byteQueue_isEmpty(&bq0)) {
			printf("<queue is empty>\n");
			break;
		}

		uint8_t x;
		const bool res = byteQueue_get(&bq0, &x);
		printf("bq.get = %d\n", (int)x);
		i = i + 1;
	}
}

#define qsize  10
static uint8_t qbuf[qsize];

int main()
{
	byteQueue_init(&bq0, (uint8_t *)&qbuf, qsize);

	padd(3);
	fetch(7);
	padd(12);
	fetch(7);
	padd(3);
	fetch(7);

	return 0;
}

