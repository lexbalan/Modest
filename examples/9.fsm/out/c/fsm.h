
#ifndef FSM_H
#define FSM_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <assert.h>
#include <stdio.h>


typedef uint16_t fsm_StageId;

typedef struct {
	struct state_desc *state;
	fsm_StageId stage;
} fsm_ComplexState;

typedef fsm_ComplexState fsm_StateServiceRoutine(fsm_ComplexState state, void *payload);

struct state_desc {
	char *id;
	uint16_t nstages;
	fsm_StateServiceRoutine *handler;
};

struct fsm {
	char *id;
	fsm_ComplexState state;
	fsm_ComplexState next_state;
	void *payload;

	uint32_t timer;
	bool timer_expired;
};
void fsm_init(struct fsm *self, char *id, struct state_desc *initState, void *payload);
void fsm_task(struct fsm *self);
void fsm_tick(struct fsm *self);
fsm_ComplexState fsm_cmdSwitchState(struct fsm *self, struct state_desc *state);
fsm_ComplexState fsm_cmdSwitchStage(struct fsm *self, uint16_t stage);
fsm_ComplexState fsm_cmdNextStage(struct fsm *self);
fsm_ComplexState fsm_cmdNextStageLimited(struct fsm *self, uint32_t t);
fsm_ComplexState fsm_getComplexState(struct fsm fsm);
struct state_desc *fsm_getState(struct fsm fsm);
fsm_StageId fsm_getStage(struct fsm fsm);
char *fsm_getStateName(struct fsm *fsm);

#endif /* FSM_H */
