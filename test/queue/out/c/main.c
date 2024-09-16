// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



void padd(int n);
void fetch(int n);
void init();





static queue_Queue q0;
static int32_t ii;

void padd(int n)
{
	int32_t i;
	i = 0;
	while (i < n) {
		if (queue_isFull((queue_Queue *)&q0)) {
			printf("queue is full\n");
			break;
		}

		printf("queue.put(%d)\n", ii);
		queue_put((queue_Queue *)&q0, (uint8_t)ii);
		i = i + 1;
		ii = ii + 1;
	}
}

void fetch(int n)
{
	int32_t i;
	i = 0;
	while (i < n) {
		if (queue_isEmpty((queue_Queue *)&q0)) {
			printf("queue is empty\n");
			break;
		}

		const uint8_t x = queue_get((queue_Queue *)&q0);
		printf("queue.get = %d\n", (int)x);
		i = i + 1;
	}
}

void init()
{
	printf("init!\n");
}

int main()
{
	init();

	queue_init((queue_Queue *)&q0);

	padd(3);
	fetch(7);
	padd(12);
	fetch(7);
	padd(22);
	fetch(7);

	return 0;
}

