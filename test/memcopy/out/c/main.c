
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>




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

	#define __len  sizeof(Object)
	printf("LEN = %u\n", (uint32_t)__len);

	memory_copy(&o2, &o1, __len);

	printf("firstname = '%s'\n", &o2.firstname);
	printf("lastname = '%s'\n", &o2.lastname);
	printf("age = %d\n", o2.age);

	return 0;

#undef __len
}

