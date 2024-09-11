// examples/fsm/src/main.cm

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include <stdio.h>
#include "./ff_delay.h"


// This is flashlight final state machine example
// (just for compiler test and language demonstration)



#include "./fsm.h"

//@attribute("c_no_print")
//import "lightfood/main"
//$pragma c_include "./ff_main.h"




#define flashlightStateOff  0
#define flashlightStateOn  1
#define flashlightStateBeacon  2


static uint8_t cnt;


//
// State Off
//

void off_entry(FSM *fsm)
{
	(void)fsm;
	//printf("off_entry\n")
}


void off_loop(FSM *fsm)
{
	(void)fsm;

	printf("off_loop\n");
	if (cnt < 10) {
		cnt = cnt + 1;
	} else {
		cnt = 0;
		fsm_switch((FSM *)fsm, flashlightStateOn);
	}
}


void off_exit(FSM *fsm)
{
	(void)fsm;
	//printf("off_exit\n")
}


//
// State On
//

void on_entry(FSM *fsm)
{
	(void)fsm;
	//printf("on_entry\n")
}


void on_loop(FSM *fsm)
{
	(void)fsm;
	printf("on_loop\n");
	if (cnt < 10) {
		cnt = cnt + 1;
	} else {
		cnt = 0;
		fsm_switch((FSM *)fsm, flashlightStateBeacon);
	}
}


void on_exit(FSM *fsm)
{
	(void)fsm;
	//printf("on_exit\n")
}


//
// State Beacon
//

void beacon_entry(FSM *fsm)
{
	char *const from_name = fsm_state_no_name((FSM *)fsm, fsm->state);
	printf("beacon_entry from %s\n", from_name);
}


void beacon_loop(FSM *fsm)
{
	printf("beacon_loop\n");
	if (cnt < 10) {
		cnt = cnt + 1;
	} else {
		cnt = 0;
		fsm_switch((FSM *)fsm, flashlightStateOff);
	}
}


void beacon_exit(FSM *fsm)
{
	char *const to_name = fsm_state_no_name((FSM *)fsm, fsm->nexstate);
	printf("beacon_exit to %s\n", to_name);
}



static FSM fsm = {
	.name = "Flash",
	.state = 0,
	.nexstate = 0,
	.substate = fsmSubstateEntering,
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



int main()
{

	while (true) {
		fsm_run((FSM *)&fsm);
		delay_ms(500);
	}

	return 0;
}

