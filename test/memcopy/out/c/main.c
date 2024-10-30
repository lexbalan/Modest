// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"





struct main_Object {
	char firstname[32];
	char lastname[32];
	int32_t age;
};
void memcopy(void *dst, void *src, uint32_t len);




void memcopy(void *dst, void *src, uint32_t len)
{
	// not worked now!
	//([len]Word8 dst) = ([len]Word8 src)
}

int main()
{
	printf("memcopy test\n");

	main_Object o1;main_Object o2;

	memcpy(&o1.firstname, &"John", sizeof(char[32]));
	memcpy(&o1.lastname, &"Doe", sizeof(char[32]));
	o1.age = 30;

	#define __len  sizeof(main_Object)
	printf("LEN = %u\n", (uint32_t)__len);

	o2 = o1;

	printf("firstname = '%s'\n", (char *)&o2.firstname);
	printf("lastname = '%s'\n", (char *)&o2.lastname);
	printf("age = %d\n", o2.age);

	return 0;

#undef __len
}

