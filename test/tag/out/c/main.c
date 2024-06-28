// test/tag/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
typedef struct Node Node;





struct Node {
	Node *next;
};

typedef int32_t MyInt;


int32_t main()
{
	printf("tag test");

	MyInt i;

	Node n0;Node n1;

	// здесь происходит проверка типов
	// и все улетает в бесконечную рекурсию
	if (memcmp(&n0, &n1, sizeof(Node)) == 0) {

	}

	//var s : Tag = #justSymbol

	return 0;
}

