
#include "fsm.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>


/*
 * FSM
 */

// State descriptor

void fsm_init(fsm_FSM *self, char *id, fsm_StateDesc *initState, void *payload) {
	self->id = id;
	self->state = (fsm_ComplexState){.state = initState, .stage = FSM_STAGE_ID_DEFAULT};
	self->next_state = (fsm_ComplexState){.state = initState, .stage = FSM_STAGE_ID_DEFAULT};
	self->payload = payload;
	self->anyPre = NULL;
	self->anyPost = NULL;
	self->timer = 0;
	self->timer_expired = false;
}



// Обработчик смены состояния
static void handlex(fsm_FSM *self) {
	if (memcmp(&self->state, &self->next_state, sizeof(fsm_ComplexState)) == 0) {
		return;
	}
	// Обрабатываем заказ на смену состояния
	const fsm_ComplexState state = self->state;
	const fsm_ComplexState next_state = self->next_state;
	printf("[%s] #%s_%u -> #%s_%u\n", self->id, state.state->id, state.stage, next_state.state->id, next_state.stage);
	self->state = self->next_state;
}



fsm_ComplexState fsm_cmdNextStage(fsm_FSM *self);

void fsm_task(fsm_FSM *self) {

	if (self->timer_expired) {
		// Clear timer & Switch to next stage
		self->timer_expired = false;
		self->next_state = fsm_cmdNextStage(self);
		const uint32_t top = 0;
		printf("[%s] fsm timeout (%u) occured, switch_to_stage(%d)\n", self->id, top, self->next_state.stage);
	}

	handlex(self);

	// Limited stage time handling
	if (self->limit != 0) {
		self->timer = self->limit;
		self->limit = 0;
	}

	// Any state Pre routine
	if (self->anyPre != NULL) {
		self->next_state = self->anyPre(self->state, self->payload);
		handlex(self);
	}

	// Usual routine
	fsm_StateServiceRoutine *const handler = self->state.state->handler;
	self->next_state = handler(self->state, self->payload);

	// Any state Post routine
	if (self->anyPost != NULL) {
		handlex(self);
		self->next_state = self->anyPost(self->state, self->payload);
	}
}


void fsm_task_1ms(fsm_FSM *self) {
	if (self->timer > 0) {
		self->timer = self->timer - 1;
		if (self->timer == 0) {
			self->timer_expired = true;
		}
	}
}


fsm_ComplexState fsm_cmdSwitchState(fsm_FSM *self, fsm_StateDesc *state) {
	self->timer = 0;
	return (fsm_ComplexState){.state = state, .stage = FSM_STAGE_ID_DEFAULT};
}


fsm_ComplexState fsm_cmdSwitchStage(fsm_FSM *self, uint16_t stage) {
	self->timer = 0;
	fsm_ComplexState newState = self->state;
	newState.stage = (fsm_StageId)stage;
	return newState;
}


fsm_ComplexState fsm_cmdNextStage(fsm_FSM *self) {
	self->timer = 0;
	const fsm_ComplexState state = self->state;
	const uint16_t nextStageIndex = (uint16_t)(state.stage) + 1;
	//assert(nextStageIndex < state.state.nstages)
	fsm_ComplexState newState = state;
	newState.stage = (fsm_StageId)nextStageIndex;
	return newState;
}


fsm_ComplexState fsm_cmdNextStageLimited(fsm_FSM *self, uint32_t t) {
	self->timer = 0;
	self->limit = t;
	const fsm_ComplexState state = self->state;
	const uint16_t nextStageIndex = (uint16_t)(state.stage) + 1;
	//assert(nextStageIndex < state.state.nstages)
	fsm_ComplexState newState = state;
	newState.stage = (fsm_StageId)nextStageIndex;
	return newState;
}


fsm_ComplexState fsm_cmdPrevStage(fsm_FSM *self) {
	self->timer = 0;
	const fsm_ComplexState state = self->state;
	const uint16_t prevStageIndex = (uint16_t)(state.stage) - 1;
	//assert(prevStageIndex < state.state.nstages)
	fsm_ComplexState newState = state;
	newState.stage = (fsm_StageId)prevStageIndex;
	return newState;
}


fsm_ComplexState fsm_getComplexState(fsm_FSM fsm) {
	return fsm.state;
}


fsm_StateDesc *fsm_getState(fsm_FSM fsm) {
	return fsm.state.state;
}


fsm_StageId fsm_getStage(fsm_FSM fsm) {
	return fsm.state.stage;
}


void fsm_setAnyPre(fsm_FSM *self, fsm_StateServiceRoutine *anyPre) {
	self->anyPre = anyPre;
}


void fsm_setAnyPost(fsm_FSM *self, fsm_StateServiceRoutine *anyPost) {
	self->anyPost = anyPost;
}


char *fsm_getCurrentStateName(fsm_FSM *fsm) {
	if (fsm->state.state == NULL) {
		return "<null>";
	}
	return fsm->state.state->id;
}


