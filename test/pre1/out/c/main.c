// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "./sub.h"
#include "./console.h"

typedef struct Node Node;


typedef uint32_t Int;

typedef int Data;

struct Node {
	Node *next;
	Data *data;
};
