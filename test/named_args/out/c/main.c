// test/named_args/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>




void print_name_age(char *name, uint32_t age)
{
	printf("name = %s\n", name);
	printf("age = %u\n", age);
}

int main()
{
	printf("test named_args\n");

	print_name_age("Alex", 34);

	return 0;
}

