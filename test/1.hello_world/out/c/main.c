// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define hello  "Hello"
#define world  "World!"
#define hello_world  (hello " " world)


struct Rec1;
typedef struct Rec1 Rec1;

struct Rec0 {
	Rec1 *p;
};
typedef struct Rec0 Rec0;

struct Rec1 {
	Rec0 *p;
};




int main()
{
	printf("%s\n", (char *)hello_world);

	Rec0 r0;
	Rec1 r1;

	r0.p = (Rec1 *)&r1;
	r1.p = (Rec0 *)&r0;

	return 0;
}

