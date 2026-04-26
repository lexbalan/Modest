
#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <stdio.h>
#include "fsm.h"
static struct fsm_fsm main_fsm0;
static fsm_ComplexState main_routine0(fsm_ComplexState state, void *payload);
static struct fsm_state_desc main_state0 = (struct fsm_state_desc){.id = "state0", .nstages = 4, .handler = &main_routine0};
static fsm_ComplexState main_routine1(fsm_ComplexState state, void *payload);
static struct fsm_state_desc main_state1 = (struct fsm_state_desc){.id = "state1", .nstages = 4, .handler = &main_routine1};
static fsm_ComplexState main_routine2(fsm_ComplexState state, void *payload);
static struct fsm_state_desc main_state2 = (struct fsm_state_desc){.id = "state2", .nstages = 4, .handler = &main_routine2};

static fsm_ComplexState main_routine0(fsm_ComplexState state, void *payload) {
	(void)payload;
	if (state.stage == (fsm_StageId)0) {
		return fsm_cmdNextStage(&main_fsm0);
	} else if (state.stage == (fsm_StageId)1) {
		return fsm_cmdNextStageLimited(&main_fsm0, 2000U);
	} else if (state.stage == (fsm_StageId)2) {
	} else if (state.stage == (fsm_StageId)3) {
		return fsm_cmdSwitchState(&main_fsm0, &main_state1);
	}
	return state;
}

static fsm_ComplexState main_routine1(fsm_ComplexState state, void *payload) {
	(void)payload;
	if (state.stage == (fsm_StageId)0) {
		return fsm_cmdNextStage(&main_fsm0);
	} else if (state.stage == (fsm_StageId)1) {
		return fsm_cmdNextStageLimited(&main_fsm0, 2000U);
	} else if (state.stage == (fsm_StageId)2) {
	} else if (state.stage == (fsm_StageId)3) {
		return fsm_cmdSwitchState(&main_fsm0, &main_state2);
	}
	return state;
}

static fsm_ComplexState main_routine2(fsm_ComplexState state, void *payload) {
	(void)payload;
	if (state.stage == (fsm_StageId)0) {
		return fsm_cmdNextStage(&main_fsm0);
	} else if (state.stage == (fsm_StageId)1) {
		return fsm_cmdNextStageLimited(&main_fsm0, 2000U);
	} else if (state.stage == (fsm_StageId)2) {
	} else if (state.stage == (fsm_StageId)3) {
		return fsm_cmdSwitchState(&main_fsm0, &main_state0);
	}
	return state;
}
static uint32_t main_timecnt;

int main(void) {
	fsm_init(&main_fsm0, "FSM_0", &main_state0, NULL);
	while (true) {
		if (main_timecnt > 55555U) {
			main_timecnt = 0U;
			fsm_tick(&main_fsm0);
		} else {
			main_timecnt = main_timecnt + 1U;
		}
		fsm_task(&main_fsm0);
	}
	return 0;
}

