
#ifndef MEMORY_H
#define MEMORY_H

#include <stdint.h>
#include <stdbool.h>



////




//$if (systemWidth == 64)


//$elseif (systemWidth == 32)
//type Word Word32
//type Nat Nat32
//$endif





void zero(void *mem, uint64_t len);


void copy(void *dst, void *src, uint64_t len);


bool eq(void *mem0, void *mem1, uint64_t len);

#endif /* MEMORY_H */
