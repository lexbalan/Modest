
#ifndef FSM_H
#define FSM_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <assert.h>
#include <stdio.h>


typedef uint16_t fsm_StageId;


struct fsm_state_desc;




typedef struct fsm_complex_state fsm_ComplexState;
struct fsm_complex_state {
	struct fsm_state_desc *state;
	fsm_StageId stage;
};

typedef fsm_ComplexState fsm_StateServiceRoutine(fsm_ComplexState state, void *payload);


struct fsm_state_desc {
	char *id;
	uint16_t nstages;
	fsm_StateServiceRoutine *handler;
};


struct fsm_fsm {
	char *id;
	fsm_ComplexState state;
	fsm_ComplexState next_state;
	void *payload;

	uint32_t timer;
	bool timer_expired;
};
void fsm_init(struct fsm_fsm *self, char *id, struct fsm_state_desc *initState, void *payload);
void fsm_task(struct fsm_fsm *self);
void fsm_tick(struct fsm_fsm *self);
fsm_ComplexState fsm_cmdSwitchState(struct fsm_fsm *self, struct fsm_state_desc *state);
fsm_ComplexState fsm_cmdSwitchStage(struct fsm_fsm *self, uint16_t stage);
fsm_ComplexState fsm_cmdNextStage(struct fsm_fsm *self);
fsm_ComplexState fsm_cmdNextStageLimited(struct fsm_fsm *self, uint32_t t);
fsm_ComplexState fsm_getComplexState(struct fsm_fsm fsm);
struct fsm_state_desc *fsm_getState(struct fsm_fsm fsm);
fsm_StageId fsm_getStage(struct fsm_fsm fsm);
char *fsm_getStateName(struct fsm_fsm *fsm);

#endif /* FSM_H */
