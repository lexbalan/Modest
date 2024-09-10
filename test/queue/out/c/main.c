// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



void fetch(Int n);
void init();



static queue_Queue q0;

void fetch(Int n)
{
	int32_t i;
	i = 0;
	while (i < 7) {
		if (queue_isEmpty((queue_Queue *)&q0)) {
			printf("queue is empty\n");
			break;
		}

		const uint8_t x = queue_get((queue_Queue *)&q0);
		printf("x = %d\n", (Int)x);
		i = i + 1;
	}
}

void init()
{
	printf("init!\n");
}

Int main()
{
	init();

	queue_init((queue_Queue *)&q0);

	queue_put((queue_Queue *)&q0, 10);
	queue_put((queue_Queue *)&q0, 20);
	queue_put((queue_Queue *)&q0, 30);
	queue_put((queue_Queue *)&q0, 40);
	queue_put((queue_Queue *)&q0, 50);

	fetch(7);

	queue_put((queue_Queue *)&q0, 40);
	queue_put((queue_Queue *)&q0, 50);
	queue_put((queue_Queue *)&q0, 60);
	queue_put((queue_Queue *)&q0, 70);
	queue_put((queue_Queue *)&q0, 80);

	fetch(7);

	queue_put((queue_Queue *)&q0, 11);
	queue_put((queue_Queue *)&q0, 12);
	queue_put((queue_Queue *)&q0, 13);
	queue_put((queue_Queue *)&q0, 14);
	queue_put((queue_Queue *)&q0, 15);

	fetch(7);

	return 0;
}

