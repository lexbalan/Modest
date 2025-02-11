
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include "main.h"

#include <stdio.h>


#include "./delay.h"

// This is flashlight final state machine example
// (just for compiler test and language demonstration)

//@attribute("c_no_print")
//import "lightfood/main"
//@attribute("c_no_print")

//$pragma c_include "./ff_main.h"


#define main_flashlightStateOff  0
#define main_flashlightStateOn  1
#define main_flashlightStateBeacon  2


static uint8_t main_cnt;


//
// State Off
//

static void main_off_entry(fsm_FSM *x)
{
	(void)x;
	//printf("off_entry\n")
}


static void main_off_loop(fsm_FSM *x)
{
	printf("off_loop\n");
	if (main_cnt < 10) {
		main_cnt = main_cnt + 1;
	} else {
		main_cnt = 0;
		fsm_switch(x, main_flashlightStateOn);
	}
}


static void main_off_exit(fsm_FSM *x)
{
	(void)x;
	//printf("off_exit\n")
}


//
// State On
//

static void main_on_entry(fsm_FSM *x)
{
	(void)x;
	//printf("on_entry\n")
}


static void main_on_loop(fsm_FSM *x)
{
	printf("on_loop\n");
	if (main_cnt < 10) {
		main_cnt = main_cnt + 1;
	} else {
		main_cnt = 0;
		fsm_switch(x, main_flashlightStateBeacon);
	}
}


static void main_on_exit(fsm_FSM *x)
{
	(void)x;
	//printf("on_exit\n")
}


//
// State Beacon
//

static void main_beacon_entry(fsm_FSM *x)
{
	char *const from_name = fsm_state_no_name(x, x->state);
	printf("beacon_entry from %s\n", from_name);
}


static void main_beacon_loop(fsm_FSM *x)
{
	printf("beacon_loop\n");
	if (main_cnt < 10) {
		main_cnt = main_cnt + 1;
	} else {
		main_cnt = 0;
		fsm_switch(x, main_flashlightStateOff);
	}
}


static void main_beacon_exit(fsm_FSM *x)
{
	char *const to_name = fsm_state_no_name(x, x->nexstate);
	printf("beacon_exit to %s\n", to_name);
}



static fsm_FSM main_fsm0 = {
	.name = "Flash",
	.state = 0,
	.nexstate = 0,
	.substate = fsm_substateEntering,
	.states = {
		{
			.name = "Off",
			.entry = &main_off_entry,
			.loop = &main_off_loop,
			.exit = &main_off_exit
		},

		{
			.name = "On",
			.entry = &main_on_entry,
			.loop = &main_on_loop,
			.exit = &main_on_exit
		},

		{
			.name = "Beacon",
			.entry = &main_beacon_entry,
			.loop = &main_beacon_loop,
			.exit = &main_beacon_exit
		}
	}
};



int main()
{

	while (true) {
		fsm_run(&main_fsm0);
		delay_ms(500);
	}

	return 0;
}

