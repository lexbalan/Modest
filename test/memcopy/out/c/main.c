
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"

#include <stdio.h>




struct main_Object {
	char firstname[32];
	char lastname[32];
	int32_t age;
};
typedef struct main_Object main_Object;


int main()
{
	printf("memcopy test\n");

	main_Object o1;
	main_Object o2;

	o1 = (main_Object){
		.firstname = "John",
		.lastname = "Doe",
		.age = 30
	};

	#define __len  sizeof(main_Object)
	printf("LEN = %u\n", (uint32_t)__len);

	memory_copy(&o2, &o1, __len);

	printf("firstname = '%s'\n", &o2.firstname);
	printf("lastname = '%s'\n", &o2.lastname);
	printf("age = %d\n", o2.age);

	return 0;

#undef __len
}

