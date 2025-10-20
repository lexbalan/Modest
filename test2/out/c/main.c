// unicode support test

#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>


struct E
{
	int32_t xx;
	int32_t aa[];
};
typedef struct E E;

int32_t main()
{
	printf("test2\n");
	return 0;
}


