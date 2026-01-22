
#ifndef FSM_H
#define FSM_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#include <assert.h>
#include <stdio.h>


typedef uint16_t fsm_StageId;


struct fsm_StateDesc;
typedef struct fsm_StateDesc fsm_StateDesc;
struct fsm_ComplexState {
	fsm_StateDesc *state;
	fsm_StageId stage;
};
typedef struct fsm_ComplexState fsm_ComplexState;

typedef fsm_ComplexState fsm_StateServiceRoutine(fsm_ComplexState state, void *payload);

struct fsm_StateDesc {
	char *id;
	uint16_t nstages;
	fsm_StateServiceRoutine *handler;
};

struct fsm_FSM {
	char *id;
	fsm_ComplexState state;
	fsm_ComplexState next_state;
	void *payload;

	uint32_t timer;
	bool timer_expired;
};
typedef struct fsm_FSM fsm_FSM;
void fsm_init(fsm_FSM *self, char *id, fsm_StateDesc *initState, void *payload);
void fsm_task(fsm_FSM *self);
void fsm_tick(fsm_FSM *self);
fsm_ComplexState fsm_cmdSwitchState(fsm_FSM *self, fsm_StateDesc *state);
fsm_ComplexState fsm_cmdSwitchStage(fsm_FSM *self, uint16_t stage);
fsm_ComplexState fsm_cmdNextStage(fsm_FSM *self);
fsm_ComplexState fsm_cmdNextStageLimited(fsm_FSM *self, uint32_t t);
fsm_ComplexState fsm_getComplexState(fsm_FSM fsm);
fsm_StateDesc *fsm_getState(fsm_FSM fsm);
fsm_StageId fsm_getStage(fsm_FSM fsm);
char *fsm_getStateName(fsm_FSM *fsm);

#endif /* FSM_H */
