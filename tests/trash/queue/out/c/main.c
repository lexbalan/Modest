
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <stdio.h>
#include "queueWord8.h"
#include "ringWord8.h"
static struct queue_word8_queue_word8 main_bq0;
static struct ring_word8_ring_word8 main_br0;
static int32_t main_ii;

static void main_fill(uint32_t n) {
	uint32_t i = 0U;
	while (i < n) {
		if (queueWord8_isFull(&main_bq0)) {
			printf("<queue is full>\n");
			break;
		}
		printf("bq.put(%d)\n", main_ii);
		queueWord8_put(&main_bq0, (uint8_t)main_ii);
		i = i + 1U;
		main_ii = main_ii + 1;
	}
}

static void main_fetch(uint32_t n) {
	uint32_t i = 0U;
	while (i < n) {
		if (queueWord8_isEmpty(&main_bq0)) {
			printf("<queue is empty>\n");
			break;
		}
		uint8_t x;
		const bool res = queueWord8_get(&main_bq0, &x);
		printf("bq.get = %d\n", (int)x);
		i = i + 1U;
	}
}
#define MAIN_QSIZE 10
static uint8_t main_qbuf[MAIN_QSIZE];

int main(void) {
	queueWord8_init(&main_bq0, (uint8_t *)&main_qbuf, MAIN_QSIZE);
	main_fill(3U);
	main_fetch(7U);
	main_fill(12U);
	main_fetch(7U);
	main_fill(3U);
	main_fetch(7U);
	return 0;
}

