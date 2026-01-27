
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <stdio.h>

#include "queueWord8.h"
#include "ringWord8.h"



static queueWord8_QueueWord8 bq0;
static ringWord8_RingWord8 br0;

static int32_t ii;
static void fill(uint32_t n) {
	uint32_t i = 0;
	while (i < n) {
		if (queueWord8_isFull(&bq0)) {
			printf("<queue is full>\n");
			break;
		}

		printf("bq.put(%d)\n", ii);
		queueWord8_put(&bq0, (uint8_t)ii);
		i = i + 1;
		ii = ii + 1;
	}
}



// выгребаем и распечатываем n значений
static void fetch(uint32_t n) {
	uint32_t i = 0;
	while (i < n) {
		if (queueWord8_isEmpty(&bq0)) {
			printf("<queue is empty>\n");
			break;
		}

		uint8_t x;
		const bool res = queueWord8_get(&bq0, &x);
		printf("bq.get = %d\n", (int)x);
		i = i + 1;
	}
}


#define QSIZE  10
static uint8_t qbuf[QSIZE];

int main(void) {
	queueWord8_init(&bq0, &qbuf, QSIZE);

	fill(3);
	fetch(7);
	fill(12);
	fetch(7);
	fill(3);
	fetch(7);

	return 0;
}


