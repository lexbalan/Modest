
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>

#include "memory.h"



struct Object {
	char firstname[32];
	char lastname[32];
	int32_t age;
};
typedef struct Object Object;

int main(void) {
	printf(/*4*/"memcopy test\n");

	Object o1;
	Object o2;

	o1 = (Object){
		.firstname = {'J', 'o', 'h', 'n'},
		.lastname = {'D', 'o', 'e'},
		.age = 30
	};

	const size_t len = sizeof(Object);
	printf(/*4*/"LEN = %zu\n", len);

	memory_copy((void *)&o2, (void *)&o1, len);

	printf(/*4*/"firstname = '%s'\n", /*4*/(char*)&o2.firstname);
	printf(/*4*/"lastname = '%s'\n", /*4*/(char*)&o2.lastname);
	printf(/*4*/"age = %d\n", o2.age);

	return 0;
}


