// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"








static byteQueue128_Word8Queue128 bq0;
static byteRing16_Word8Ring16 br0;
static int32_t ii;

static void padd(int n)
{
	int32_t i = 0;
	while (i < n) {
		if (byteQueue128_isFull((byteQueue128_Word8Queue128 *)&bq0)) {
			printf("queue is full\n");
			break;
		}

		printf("bq.put(%d)\n", ii);
		byteQueue128_put((byteQueue128_Word8Queue128 *)&bq0, (uint8_t)ii);
		i = i + 1;
		ii = ii + 1;
	}
}
// выгребаем все и печатаем в консоль

static void fetch(int n)
{
	int32_t i = 0;
	while (i < n) {
		if (byteQueue128_isEmpty((byteQueue128_Word8Queue128 *)&bq0)) {
			printf("queue is empty\n");
			break;
		}

		uint8_t x;
		const bool res = byteQueue128_get((byteQueue128_Word8Queue128 *)&bq0, &x);
		printf("bq.get = %d\n", (int)x);
		i = i + 1;
	}
}

int main()
{
	byteQueue128_init((byteQueue128_Word8Queue128 *)&bq0);

	padd(3);
	fetch(7);
	padd(12);
	fetch(7);
	padd(22);
	fetch(7);

	return 0;
}

