// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define flashlightStateOff  0
#define flashlightStateOn  1
#define flashlightStateBeacon  2
int main();





static uint8_t cnt;
static fsm_FSM fsm = {
	.name = "Flash",
	.state = 0,
	.nexstate = 0,
	.substate = <bad>
