
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <math.h>
#include <stdio.h>

#include "main.h"

//import "./byteRing16" as br


static byteQueue128_Queue128Word8 bq0;
//var br0: br.Word8Ring16


static int32_t ii;
static void padd(int n)
{
	int32_t i = 0;
	while (i < n) {
		if (byteQueue128_isFull(&bq0)) {
			printf("queue is full\n");
			break;
		}

		printf("bq.put(%d)\n", ii);
		byteQueue128_put(&bq0, (uint8_t)ii);
		i = i + 1;
		ii = ii + 1;
	}
}


// выгребаем все и печатаем в консоль
static void fetch(int n)
{
	int32_t i = 0;
	while (i < n) {
		if (byteQueue128_isEmpty(&bq0)) {
			printf("queue is empty\n");
			break;
		}

		uint8_t x;
		const bool res = byteQueue128_get(&bq0, &x);
		printf("bq.get = %d\n", (int)x);
		i = i + 1;
	}
}



int main()
{
	byteQueue128_init(&bq0);

	padd(3);
	fetch(7);
	padd(12);
	fetch(7);
	padd(3);
	fetch(7);

	return 0;
}

