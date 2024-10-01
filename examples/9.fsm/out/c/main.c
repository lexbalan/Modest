// ./out/c/main.c

#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#include "main.h"



#define main_flashlightStateOff  0
#define main_flashlightStateOn  1
#define main_flashlightStateBeacon  2
void off_entry(fsm_FSM *x);
void off_loop(fsm_FSM *x);
void off_exit(fsm_FSM *x);
void on_entry(fsm_FSM *x);
void on_loop(fsm_FSM *x);
void on_exit(fsm_FSM *x);
void beacon_entry(fsm_FSM *x);
void beacon_loop(fsm_FSM *x);
void beacon_exit(fsm_FSM *x);
int main();





static uint8_t cnt;
static fsm_FSM fsm = {
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

void off_entry(fsm_FSM *x)
{
	(void)x;
	//printf("off_entry\n")
}

void off_loop(fsm_FSM *x)
{
	printf("off_loop\n");
	if (cnt < 10) {
		cnt = cnt + 1;
	} else {
		cnt = 0;
		fsm_switch((fsm_FSM *)x, main_flashlightStateOn);
	}
}

void off_exit(fsm_FSM *x)
{
	(void)x;
	//printf("off_exit\n")
}

void on_entry(fsm_FSM *x)
{
	(void)x;
	//printf("on_entry\n")
}

void on_loop(fsm_FSM *x)
{
	printf("on_loop\n");
	if (cnt < 10) {
		cnt = cnt + 1;
	} else {
		cnt = 0;
		fsm_switch((fsm_FSM *)x, main_flashlightStateBeacon);
	}
}

void on_exit(fsm_FSM *x)
{
	(void)x;
	//printf("on_exit\n")
}

void beacon_entry(fsm_FSM *x)
{
	char *const from_name = fsm_state_no_name((fsm_FSM *)x, x->state);
	printf("beacon_entry from %s\n", from_name);
}

void beacon_loop(fsm_FSM *x)
{
	printf("beacon_loop\n");
	if (cnt < 10) {
		cnt = cnt + 1;
	} else {
		cnt = 0;
		fsm_switch((fsm_FSM *)x, main_flashlightStateOff);
	}
}

void beacon_exit(fsm_FSM *x)
{
	char *const to_name = fsm_state_no_name((fsm_FSM *)x, x->nexstate);
	printf("beacon_exit to %s\n", to_name);
}

int main()
{

	while (true) {
		fsm_run((fsm_FSM *)&fsm);
		delay_ms(500);
	}

	return 0;
}

