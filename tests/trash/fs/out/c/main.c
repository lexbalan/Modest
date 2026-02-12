
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include <assert.h>



#define BLOCK_SIZE  4096
#define NBLOCKS  1024

struct Block {
	uint8_t data[BLOCK_SIZE];
};
typedef struct Block Block;
static Block disk[NBLOCKS];

static int dread(uint32_t n, Block *block) {
	//assert(n < nblocks)
	*block = disk[n];
	return 0;
}


static int dwrite(uint32_t n, Block *block) {
	//assert(n < nblocks)
	disk[n] = *block;
	return 0;
}


#define FBLOCKS  16

struct Super {
	uint32_t root;
};
typedef struct Super Super;

struct Inode {
	uint32_t size;
	uint32_t blocks[FBLOCKS];
};
typedef struct Inode Inode;

static int inodeRead(uint32_t n, Inode *inode) {
	dread(n, (Block *)inode);
	return 0;
}


static int bread(Inode *inode, uint32_t nblock, Block *block) {
	//
	return 0;
}


static Super super;

int main(void) {
	dread(0, (Block *)&super);
	super.root = 1;

	Inode inode;
	inodeRead(1, &inode);

	return 0;
}


