// lightfood/memory.m

#ifndef MEMORY_H
#define MEMORY_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

void memory_zero(void *mem, uint64_t len);
void memory_copy(void *dst, void *src, uint64_t len);
bool memory_eq(void *mem0, void *mem1, uint64_t len);

#endif /* MEMORY_H */
