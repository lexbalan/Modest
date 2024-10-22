
#ifndef MAIN_H
#define MAIN_H

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "delay.h"

typedef struct main_GPIO main_GPIO; //
#define main_portB  ((main_GPIO *)(main_sfrOffset + 0x03))
#define main_portC  ((main_GPIO *)(main_sfrOffset + 0x06))
#define main_portD  ((main_GPIO *)(main_sfrOffset + 0x09))
int16_t main();

#endif /* MAIN_H */
