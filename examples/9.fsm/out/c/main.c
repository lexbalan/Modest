
#include "main.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>



static fsm_FSM fsm0;


static fsm_ComplexState routine0(fsm_ComplexState state, void *payload);
static fsm_StateDesc state0 = {.id = "state0", .nstages = 4, .handler = &routine0};

static fsm_ComplexState routine1(fsm_ComplexState state, void *payload);
static fsm_StateDesc state1 = {.id = "state1", .nstages = 4, .handler = &routine1};

static fsm_ComplexState routine2(fsm_ComplexState state, void *payload);
static fsm_StateDesc state2 = {.id = "state2", .nstages = 4, .handler = &routine2};

static fsm_ComplexState routine0(fsm_ComplexState state, void *payload) {
	(void)payload;
	if (state.stage == (fsm_StageId)0) {
		return fsm_cmdNextStage(&fsm0);
	} else if (state.stage == (fsm_StageId)1) {
		return fsm_cmdNextStageLimited(&fsm0, 2000);
	} else if (state.stage == (fsm_StageId)2) {
		// just stay
	} else if (state.stage == (fsm_StageId)3) {
		return fsm_cmdSwitchState(&fsm0, &state1);
	}
	return state;
}


static fsm_ComplexState routine1(fsm_ComplexState state, void *payload) {
	(void)payload;
	if (state.stage == (fsm_StageId)0) {
		return fsm_cmdNextStage(&fsm0);
	} else if (state.stage == (fsm_StageId)1) {
		return fsm_cmdNextStageLimited(&fsm0, 2000);
	} else if (state.stage == (fsm_StageId)2) {
		// just stay
	} else if (state.stage == (fsm_StageId)3) {
		return fsm_cmdSwitchState(&fsm0, &state2);
	}
	return state;
}


static fsm_ComplexState routine2(fsm_ComplexState state, void *payload) {
	(void)payload;
	if (state.stage == (fsm_StageId)0) {
		return fsm_cmdNextStage(&fsm0);
	} else if (state.stage == (fsm_StageId)1) {
		return fsm_cmdNextStageLimited(&fsm0, 2000);
	} else if (state.stage == (fsm_StageId)2) {
		// just stay
	} else if (state.stage == (fsm_StageId)3) {
		return fsm_cmdSwitchState(&fsm0, &state0);
	}
	return state;
}


static uint32_t timecnt;

int main(void) {
	fsm_init(&fsm0, "FSM_0", &state0, NULL);

	while (true) {
		if (timecnt > 55555) {
			timecnt = 0;
			fsm_tick(&fsm0);
		} else {
			timecnt = timecnt + 1;
		}

		fsm_task(&fsm0);
	}

	return 0;
}


