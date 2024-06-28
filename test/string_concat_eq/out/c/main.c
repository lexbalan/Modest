// test/string_concat_eq/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>



#define hello  "Hello"
#define world  "World"
#define party_corn  U"🎉"

#define greeting  (hello " " world)//+ " " + party_corn


#define test  "test"


int32_t main()
{
	printf("%s\n", (char *)greeting);

	if (true) {
		printf("test ok.\n");
	} else {
		printf("test failed.\n");
	}

	return 0;
}

