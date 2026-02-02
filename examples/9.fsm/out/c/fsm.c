
#include "fsm.h"

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>
#include <assert.h>
#include <stdio.h>



void fsm_init(struct fsm_fsm *self, char *id, struct fsm_state_desc *initState, void *payload) {
	self->id = id;
	self->state = (fsm_ComplexState){.state = initState, .stage = (fsm_StageId)0};
	self->next_state = (fsm_ComplexState){.state = initState, .stage = (fsm_StageId)0};
	self->payload = payload;
	self->timer = 0;
	self->timer_expired = false;
}



fsm_ComplexState fsm_cmdNextStage(struct fsm_fsm *self);

void fsm_task(struct fsm_fsm *self) {
	// Сработал таймер-ограничитель времени нахождения в стадии?
	if (self->timer_expired) {
		// Clear timer & Switch to next stage
		self->timer_expired = false;
		self->next_state = fsm_cmdNextStage(self);
		const uint32_t top = 0;
		printf("[%s] fsm timeout (%u) occured, switch_to_stage(%d)\n", (char*)self->id, top, (fsm_StageId)self->next_state.stage);
	}

	// Есть запрос на смену состояния?
	if (memcmp(&self->next_state, &self->state, sizeof(fsm_ComplexState)) != 0) {
		const fsm_ComplexState state = self->state;
		const fsm_ComplexState next_state = self->next_state;
		printf("[%s] #%s_%u -> #%s_%u\n", (char*)self->id, (char*)state.state->id, (fsm_StageId)state.stage, (char*)next_state.state->id, (fsm_StageId)next_state.stage);
		self->state = self->next_state;
	}

	// Usual routine
	fsm_StateServiceRoutine *const handler = self->state.state->handler;
	self->next_state = handler(self->state, self->payload);
}


void fsm_tick(struct fsm_fsm *self) {
	if (self->timer > 0) {
		self->timer = self->timer - 1;
		if (self->timer == 0) {
			self->timer_expired = true;
		}
	}
}


fsm_ComplexState fsm_cmdSwitchState(struct fsm_fsm *self, struct fsm_state_desc *state) {
	self->timer = 0;
	self->timer_expired = false;
	return (fsm_ComplexState){.state = state, .stage = (fsm_StageId)0};
}


fsm_ComplexState fsm_cmdSwitchStage(struct fsm_fsm *self, uint16_t stage) {
	self->timer = 0;
	self->timer_expired = false;
	fsm_ComplexState newState = self->state;
	newState.stage = (fsm_StageId)stage;
	return newState;
}


fsm_ComplexState fsm_cmdNextStage(struct fsm_fsm *self) {
	self->timer = 0;
	self->timer_expired = false;
	const fsm_ComplexState state = self->state;
	const uint16_t nextStageIndex = (uint16_t)(state.stage) + 1;
	//assert(nextStageIndex < state.state.nstages)
	fsm_ComplexState newState = state;
	newState.stage = (fsm_StageId)nextStageIndex;
	return newState;
}


fsm_ComplexState fsm_cmdNextStageLimited(struct fsm_fsm *self, uint32_t t) {
	self->timer = t;
	const fsm_ComplexState state = self->state;
	const uint16_t nextStageIndex = (uint16_t)(state.stage) + 1;
	//assert(nextStageIndex < state.state.nstages)
	fsm_ComplexState newState = state;
	newState.stage = (fsm_StageId)nextStageIndex;
	return newState;
}


fsm_ComplexState fsm_getComplexState(struct fsm_fsm fsm) {
	return fsm.state;
}


struct fsm_state_desc *fsm_getState(struct fsm_fsm fsm) {
	return fsm.state.state;
}


fsm_StageId fsm_getStage(struct fsm_fsm fsm) {
	return fsm.state.stage;
}


char *fsm_getStateName(struct fsm_fsm *fsm) {
	if (fsm->state.state == NULL) {
		return "<null>";
	}
	return fsm->state.state->id;
}


