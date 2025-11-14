// tests/threads/src/main.m
// valgrind --leak-check=full ./easy.run

#ifndef MAIN_H
#define MAIN_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

int main(void);

#endif /* MAIN_H */
