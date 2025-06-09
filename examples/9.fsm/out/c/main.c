
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "./delay.h"
#include <stdio.h>

#include "main.h"


#define flashlightStateOff  0
#define flashlightStateOn  1
#define flashlightStateBeacon  2

static uint8_t cnt;

static void off_entry(fsm_FSM *x) {
	(void)x;
	//printf("off_entry\n")
}

static void off_loop(fsm_FSM *x) {
	printf("off_loop\n");
	if (cnt < 10) {
		cnt = cnt + 1;
	} else {
		cnt = 0;
		fsm_switch(x, flashlightStateOn);
	}
}

static void off_exit(fsm_FSM *x) {
	(void)x;
	//printf("off_exit\n")
}

static void on_entry(fsm_FSM *x) {
	(void)x;
	//printf("on_entry\n")
}

static void on_loop(fsm_FSM *x) {
	printf("on_loop\n");
	if (cnt < 10) {
		cnt = cnt + 1;
	} else {
		cnt = 0;
		fsm_switch(x, flashlightStateBeacon);
	}
}

static void on_exit(fsm_FSM *x) {
	(void)x;
	//printf("on_exit\n")
}

static void beacon_entry(fsm_FSM *x) {
	char *const from_name = fsm_state_no_name(x, x->state);
	printf("beacon_entry from %s\n", from_name);
}

static void beacon_loop(fsm_FSM *x) {
	printf("beacon_loop\n");
	if (cnt < 10) {
		cnt = cnt + 1;
	} else {
		cnt = 0;
		fsm_switch(x, flashlightStateOff);
	}
}

static void beacon_exit(fsm_FSM *x) {
	char *const to_name = fsm_state_no_name(x, x->nexstate);
	printf("beacon_exit to %s\n", to_name);
}

static fsm_FSM fsm0 = {
	.name = "Flash",
	.state = 0,
	.nexstate = 0,
	.substate = fsm_substateEntering,
	.states = {
		{
			.name = "Off",
			.entry = &off_entry,
			.loop = &off_loop,
			.exit = &off_exit
		},

		{
			.name = "On",
			.entry = &on_entry,
			.loop = &on_loop,
			.exit = &on_exit
		},

		{
			.name = "Beacon",
			.entry = &beacon_entry,
			.loop = &beacon_loop,
			.exit = &beacon_exit
		}
	}
};

int main() {

	while (true) {
		fsm_run(&fsm0);
		delay_ms(500);
	}

	return 0;
}

