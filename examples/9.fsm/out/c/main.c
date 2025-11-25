
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "./delay.h"



// This is flashlight final state machine example
// (just for compiler test and language demonstration)

// This is flashlight final state machine example
// (just for compiler test and language demonstration)

#define FLASHLIGHT_STATE_OFF  0
#define FLASHLIGHT_STATE_ON  1
#define FLASHLIGHT_STATE_BEACON  2

static uint8_t cnt;

//
// State Off
//

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
		fsm_switch(x, FLASHLIGHT_STATE_ON);
	}
}


static void off_exit(fsm_FSM *x) {
	(void)x;
	//printf("off_exit\n")
}


//
// State On
//

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
		fsm_switch(x, FLASHLIGHT_STATE_BEACON);
	}
}


static void on_exit(fsm_FSM *x) {
	(void)x;
	//printf("on_exit\n")
}


//
// State Beacon
//

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
		fsm_switch(x, FLASHLIGHT_STATE_OFF);
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
	.substate = FSM_SUBSTATE_ENTERING,
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

int main(void) {
	while (true) {
		fsm_run(&fsm0);
		delay_ms(500);
	}

	return 0;
}


