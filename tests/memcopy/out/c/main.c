// tests/1.hello_world/src/main.m

#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "main.h"


struct Object {
	char firstname[32];
	char lastname[32];
	int32_t age;
};
typedef struct Object Object;

int main()
{
	printf("memcopy test\n");

	Object o1;
	Object o2;

	o1 = (Object){
		.firstname = "John",
		.lastname = "Doe",
		.age = 30
	};

	const uint8_t len = sizeof(Object);
	printf("LEN = %u\n", (uint32_t)len);

	memory_copy(&o2, &o1, (uint64_t)len);

	printf("firstname = '%s'\n", &o2.firstname);
	printf("lastname = '%s'\n", &o2.lastname);
	printf("age = %d\n", o2.age);

	return 0;
}

